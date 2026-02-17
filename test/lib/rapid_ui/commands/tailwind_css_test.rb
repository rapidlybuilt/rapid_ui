require "test_helper"
require "fileutils"
require "tempfile"
require "spy"
require "stringio"

module RapidUI
  module Commands
    class TailwindCSSTest < ActiveSupport::TestCase
      def setup
        @configs = {
          main: {
            input: "app/assets/stylesheets/application.css",
            output: "app/assets/builds/application.css",
            build_dir: "app/assets/builds",
          },
          docs: {
            input: "docs/app/assets/stylesheets/docs.css",
            output: "docs/app/assets/builds/docs.css",
            build_dir: "docs/app/assets/builds",
            import: [ "rapid_ui/base" ],
          },
        }
        @quiet_command = TailwindCSS.new(@configs, quiet: true)
        @command = TailwindCSS.new(@configs)
      end

      test "initializes with configs" do
        assert_equal @configs, @quiet_command.configs
        assert_equal true, @quiet_command.quiet
      end

      test "initializes with quiet parameter" do
        quiet_command = TailwindCSS.new(@configs, quiet: true)
        assert_equal true, quiet_command.quiet
      end

      test "initializes with just config and no options" do
        command = TailwindCSS.new(main: {})
        assert_equal [ :main ], command.configs.keys
      end

      test "execute with build command calls prepare_imports and run_command" do
        prepare_spy = Spy.on(@quiet_command, :prepare_imports)
        run_spy = Spy.on(@quiet_command, :run_command)
        @quiet_command.execute("build", :main)
        assert_equal 1, prepare_spy.calls.length
        assert_equal [ :main ], prepare_spy.calls.first.args
        assert_equal 1, run_spy.calls.length
        assert_kind_of String, run_spy.calls.first.args.first
      end

      test "execute with watch command calls prepare_imports and run_command" do
        prepare_spy = Spy.on(@quiet_command, :prepare_imports)
        run_spy = Spy.on(@quiet_command, :run_command)
        @quiet_command.execute("watch", :main)
        assert_equal 1, prepare_spy.calls.length
        assert_equal [ :main ], prepare_spy.calls.first.args
        assert_equal 1, run_spy.calls.length
        assert_kind_of String, run_spy.calls.first.args.first
      end

      test "execute with clean command calls run_command" do
        run_spy = Spy.on(@quiet_command, :run_command)
        @quiet_command.execute("clean", :main)
        assert_equal 1, run_spy.calls.length
        assert_kind_of String, run_spy.calls.first.args.first
      end

      test "execute with help command shows help" do
        assert_output(/Usage:/) do
          @command.execute("help")
        end
      end

      test "execute with nil command shows error and exits" do
        assert_output(/Error: No command specified/) do
          assert_raises(SystemExit) do
            @command.execute(nil)
          end
        end
      end

      test "execute with unknown command shows error and exits" do
        assert_output(/Error: Unknown command 'invalid'/) do
          assert_raises(SystemExit) do
            @command.execute("invalid")
          end
        end
      end

      test "build_command returns correct command string" do
        config = @configs[:main]
        expected = "bundle exec tailwindcss -i #{config[:input]} -o #{config[:output]}"
        assert_equal expected, @quiet_command.build_command(:main)
      end

      test "watch_command returns correct command string" do
        config = @configs[:main]
        expected = "bundle exec tailwindcss -i #{config[:input]} -o #{config[:output]} --watch"
        assert_equal expected, @quiet_command.watch_command(:main)
      end

      test "clean_command returns correct command string" do
        config = @configs[:main]
        expected = "rm -rf #{config[:build_dir]}"
        assert_equal expected, @quiet_command.clean_command(:main)
      end

      test "get_config returns config for valid target" do
        assert_equal @configs[:main], @quiet_command.send(:get_config, :main)
        assert_equal @configs[:docs], @quiet_command.send(:get_config, :docs)
      end

      test "get_config returns nil config for main target when target is DEFAULT_TARGET" do
        configs_with_nil = {
          nil => @configs[:main],
        }
        command = TailwindCSS.new(configs_with_nil, quiet: true)
        assert_equal configs_with_nil[nil], command.send(:get_config, TailwindCSS::DEFAULT_TARGET)
      end

      test "get_config raises ArgumentError for unknown target" do
        assert_raises(ArgumentError, "Unknown target: :invalid") do
          @quiet_command.send(:get_config, :invalid)
        end
      end

      test "has_imports? returns true when config has import array" do
        config = @configs[:docs]
        assert @quiet_command.send(:has_imports?, config)
      end

      test "has_imports? returns false when config has no import" do
        config = @configs[:main]
        assert_not @quiet_command.send(:has_imports?, config)
      end

      test "has_imports? returns false when config has empty import array" do
        config = { input: "test.css", output: "test.css", build_dir: "build", import: [] }
        assert_not @quiet_command.send(:has_imports?, config)
      end

      test "temp_file_name returns correct filename" do
        assert_equal "main.css", @quiet_command.send(:temp_file_name, :main)
        assert_equal "docs.css", @quiet_command.send(:temp_file_name, :docs)
      end

      test "temp_file_path returns correct path" do
        expected = File.join(TailwindCSS::TEMP_DIR, "main.css")
        assert_equal expected, @quiet_command.send(:temp_file_path, :main)
      end

      test "effective_input returns temp file path when imports exist" do
        config = @configs[:docs]
        expected = @quiet_command.send(:temp_file_path, :docs)
        assert_equal expected, @quiet_command.send(:effective_input, :docs, config)
      end

      test "effective_input returns original input when no imports" do
        config = @configs[:main]
        assert_equal config[:input], @quiet_command.send(:effective_input, :main, config)
      end

      test "prepare_imports creates temp file with imports" do
        temp_dir = TailwindCSS::TEMP_DIR
        FileUtils.mkdir_p(temp_dir)
        temp_file = File.join(temp_dir, "docs.css")

        begin
          @quiet_command.send(:prepare_imports, :docs)

          assert File.exist?(temp_file)
          content = File.read(temp_file)
          assert_match(/@import/, content)
          assert_match(/rapid_ui\/base/, content)
          assert_match(/docs\.css/, content)
        ensure
          FileUtils.rm_rf(temp_dir) if Dir.exist?(temp_dir)
        end
      end

      test "prepare_imports does nothing when no imports" do
        temp_file_called = false
        @quiet_command.stub(:temp_file_path, ->(_) { temp_file_called = true; "" }) do
          @quiet_command.send(:prepare_imports, :main)
        end
        assert_equal false, temp_file_called
      end

      test "normalize_target returns DEFAULT_TARGET for nil" do
        assert_equal TailwindCSS::DEFAULT_TARGET, @quiet_command.send(:normalize_target, nil)
      end

      test "normalize_target returns symbol for existing key" do
        assert_equal :main, @quiet_command.send(:normalize_target, :main)
        assert_equal :docs, @quiet_command.send(:normalize_target, :docs)
      end

      test "normalize_target converts string to symbol" do
        assert_equal :main, @quiet_command.send(:normalize_target, "main")
        assert_equal :docs, @quiet_command.send(:normalize_target, "docs")
      end

      test "normalize_target converts to lowercase" do
        assert_equal :main, @quiet_command.send(:normalize_target, "MAIN")
        assert_equal :docs, @quiet_command.send(:normalize_target, "DOCS")
      end

      test "parse_options handles help option" do
        args = [ "--help" ]
        assert_output(/Usage:/) do
          assert_raises(SystemExit) do
            @command.send(:parse_options, args.dup)
          end
        end
      end

      test "run with build command" do
        args = [ "build" ]
        execute_spy = Spy.on(@quiet_command, :execute)
        @quiet_command.run(args)
        assert_equal 1, execute_spy.calls.length
        assert_equal "build", execute_spy.calls.first.args.first
      end

      test "run with target option" do
        args = [ "build", "--target", "docs" ]
        execute_spy = Spy.on(@quiet_command, :execute)
        @quiet_command.run(args)
        assert_equal 1, execute_spy.calls.length
        assert_equal "build", execute_spy.calls.first.args.first
        assert_equal :docs, execute_spy.calls.first.args.second
      end

      test "show_help displays usage information" do
        output = StringIO.new
        original_stdout = $stdout
        $stdout = output
        begin
          @command.show_help
        ensure
          $stdout = original_stdout
        end

        output_string = output.string
        assert_match(/Usage:/, output_string)
        assert_match(/Commands:/, output_string)
        assert_match(/build/, output_string)
        assert_match(/watch/, output_string)
        assert_match(/clean/, output_string)
        assert_match(/Options:/, output_string)
        assert_match(/--target TARGET/, output_string)
        assert_match(/Examples:/, output_string)
      end

      test "show_help includes target names in options" do
        output = StringIO.new
        original_stdout = $stdout
        $stdout = output
        begin
          @command.show_help
        ensure
          $stdout = original_stdout
        end

        output_string = output.string
        assert_match(/main/, output_string)
        assert_match(/docs/, output_string)
      end

      test "run_command executes system command" do
        command = "echo test"
        system_called_with = nil
        @quiet_command.stub(:system, ->(cmd) { system_called_with = cmd; true }) do
          @quiet_command.stub(:puts, ->(_) { }) do
            @quiet_command.send(:run_command, command)
          end
        end
        assert_equal command, system_called_with
      end

      test "resolve_import_path resolves rapid_ui prefix" do
        path = "rapid_ui/base"
        result = TailwindCSS.resolve_import_path(path)

        expected_base = File.join(TailwindCSS::GEM_ROOT, "app/assets/stylesheets")
        expected = File.join(expected_base, "#{path}.css")
        assert_equal expected, result
      end

      test "resolve_import_path returns path as-is when no prefix matches" do
        path = "some/other/path"
        assert_equal path, TailwindCSS.resolve_import_path(path)
      end

      test "register_import_path adds new import path" do
        TailwindCSS.register_import_path("test_prefix", "/test/path")
        assert_equal "/test/path", TailwindCSS.import_paths["test_prefix"]

        # Clean up
        TailwindCSS.import_paths.delete("test_prefix")
      end

      test "import_paths includes rapid_ui by default" do
        paths = TailwindCSS.import_paths
        assert paths.key?("rapid_ui")
        expected = File.join(TailwindCSS::GEM_ROOT, "app/assets/stylesheets")
        assert_equal expected, paths["rapid_ui"]
      end

      test "quiet mode suppresses output" do
        quiet_command = TailwindCSS.new(@configs, quiet: true)
        output = StringIO.new
        original_stdout = $stdout
        $stdout = output
        begin
          quiet_command.show_help
        ensure
          $stdout = original_stdout
        end

        assert_equal "", output.string
      end

      test "quiet mode suppresses run_command output" do
        quiet_command = TailwindCSS.new(@configs, quiet: true)
        output = StringIO.new
        original_stdout = $stdout
        $stdout = output
        begin
          quiet_command.stub(:system, ->(_) { true }) do
            quiet_command.send(:run_command, "echo test")
          end
        ensure
          $stdout = original_stdout
        end

        assert_equal "", output.string
      end

      test "quiet mode suppresses prepare_imports output" do
        quiet_command = TailwindCSS.new(@configs, quiet: true)
        temp_dir = TailwindCSS::TEMP_DIR
        FileUtils.mkdir_p(temp_dir)

        begin
          output = StringIO.new
          original_stdout = $stdout
          $stdout = output
          begin
            quiet_command.send(:prepare_imports, :docs)
          ensure
            $stdout = original_stdout
          end

          assert_equal "", output.string
        ensure
          FileUtils.rm_rf(temp_dir) if Dir.exist?(temp_dir)
        end
      end

      test "default behavior shows output" do
        output = StringIO.new
        original_stdout = $stdout
        $stdout = output
        begin
          @command.show_help
        ensure
          $stdout = original_stdout
        end

        assert_not_equal "", output.string
      end
    end
  end
end
