require "test_helper"
require "fileutils"
require "tempfile"
require "spy"
require "stringio"

module RapidUI
  module Commands
    class IconsTest < ActiveSupport::TestCase
      def setup
        @base_dir = Dir.mktmpdir("rapid_ui_icons_test")
        @command = Icons.new(base_dir: @base_dir)
        @quiet_command = Icons.new(base_dir: @base_dir, quiet: true)
      end

      def teardown
        FileUtils.rm_rf(@base_dir) if Dir.exist?(@base_dir)
      end

      test "initializes with base_dir" do
        assert_equal @base_dir, @command.base_dir
      end

      test "initializes with quiet parameter" do
        assert_equal true, @quiet_command.quiet
      end

      test "tmp_dir returns correct path" do
        expected = File.join(@base_dir, "tmp")
        assert_equal expected, @command.tmp_dir
      end

      test "vendor_dir returns correct path" do
        expected = File.join(@base_dir, "vendor")
        assert_equal expected, @command.vendor_dir
      end

      test "tmp_icons_dir returns correct path" do
        expected = File.join(@base_dir, "tmp", "lucide-icons")
        assert_equal expected, @command.tmp_icons_dir
      end

      test "vendor_icons_dir returns correct path" do
        expected = File.join(@base_dir, "vendor", "lucide_icons")
        assert_equal expected, @command.vendor_icons_dir
      end

      test "tmp_version_file returns correct path" do
        expected = File.join(@base_dir, "tmp", "lucide-icons", "VERSION")
        assert_equal expected, @command.tmp_version_file
      end

      test "vendor_version_file returns correct path" do
        expected = File.join(@base_dir, "vendor", "lucide_icons", "VERSION")
        assert_equal expected, @command.vendor_version_file
      end

      test "run with import action calls import_icon" do
        icon_name = "check"
        import_spy = Spy.on(@command, :import_icon)
        @command.run([ "import", icon_name ])
        assert_equal 1, import_spy.calls.length
        assert_equal [ icon_name ], import_spy.calls.first.args
      end

      test "run with upgrade action calls upgrade_version" do
        version = "0.550.0"
        upgrade_spy = Spy.on(@command, :upgrade_version)
        @command.run([ "upgrade", version ])
        assert_equal 1, upgrade_spy.calls.length
        assert_equal [ version ], upgrade_spy.calls.first.args
      end

      test "run with insufficient arguments shows usage and exits" do
        assert_output(/❌ Not enough arguments/) do
          assert_raises(SystemExit) do
            @command.run([ "import" ])
          end
        end
      end

      test "run with unknown action shows error and exits" do
        assert_output(/❌ Unknown action: invalid/) do
          assert_raises(SystemExit) do
            @command.run([ "invalid", "arg" ])
          end
        end
      end

      test "import_icon with nil name shows error and exits" do
        assert_output(/❌ Please provide an icon name/) do
          assert_raises(SystemExit) do
            @command.import_icon(nil)
          end
        end
      end

      test "import_icon with empty name shows error and exits" do
        assert_output(/❌ Please provide an icon name/) do
          assert_raises(SystemExit) do
            @command.import_icon("")
          end
        end
      end

      test "upgrade_version with nil version shows error and exits" do
        assert_output(/❌ Please provide a version number/) do
          assert_raises(SystemExit) do
            @command.upgrade_version(nil)
          end
        end
      end

      test "upgrade_version with empty version shows error and exits" do
        assert_output(/❌ Please provide a version number/) do
          assert_raises(SystemExit) do
            @command.upgrade_version("")
          end
        end
      end

      test "current_tmp_version returns version when file exists" do
        FileUtils.mkdir_p(File.dirname(@command.tmp_version_file))
        File.write(@command.tmp_version_file, "0.545.0\n")
        assert_equal "0.545.0", @command.send(:current_tmp_version)
      end

      test "current_tmp_version returns nil when file does not exist" do
        assert_nil @command.send(:current_tmp_version)
      end

      test "current_vendor_version returns version when file exists" do
        FileUtils.mkdir_p(File.dirname(@command.vendor_version_file))
        File.write(@command.vendor_version_file, "0.545.0\n")
        assert_equal "0.545.0", @command.send(:current_vendor_version)
      end

      test "current_vendor_version returns nil when file does not exist" do
        assert_nil @command.send(:current_vendor_version)
      end

      test "find_icon_in_extracted finds icon by exact name" do
        icon_name = "check"
        FileUtils.mkdir_p(@command.tmp_icons_dir)
        icon_path = File.join(@command.tmp_icons_dir, "#{icon_name}.svg")
        File.write(icon_path, "<svg></svg>")

        result = @command.send(:find_icon_in_extracted, icon_name)
        assert_equal icon_path, result
      end

      test "find_icon_in_extracted finds icon with kebab-case conversion" do
        icon_name = "chevronDown"
        kebab_name = "chevron-down"
        FileUtils.mkdir_p(@command.tmp_icons_dir)
        icon_path = File.join(@command.tmp_icons_dir, "#{kebab_name}.svg")
        File.write(icon_path, "<svg></svg>")

        result = @command.send(:find_icon_in_extracted, icon_name)
        assert_equal icon_path, result
      end

      test "find_icon_in_extracted returns nil when icon not found" do
        FileUtils.mkdir_p(@command.tmp_icons_dir)
        result = @command.send(:find_icon_in_extracted, "nonexistent")
        assert_nil result
      end

      test "move_icon_to_vendor creates vendor directory if it doesn't exist" do
        icon_name = "check"
        FileUtils.mkdir_p(@command.tmp_icons_dir)
        File.write(File.join(@command.tmp_icons_dir, "#{icon_name}.svg"), "<svg></svg>")
        File.write(@command.tmp_version_file, "0.545.0")

        @command.send(:move_icon_to_vendor, icon_name)

        assert Dir.exist?(@command.vendor_icons_dir)
        assert File.exist?(File.join(@command.vendor_icons_dir, "#{icon_name}.svg"))
      end

      test "move_icon_to_vendor copies version file from tmp to vendor" do
        icon_name = "check"
        FileUtils.mkdir_p(@command.tmp_icons_dir)
        File.write(File.join(@command.tmp_icons_dir, "#{icon_name}.svg"), "<svg></svg>")
        File.write(@command.tmp_version_file, "0.545.0")

        @command.send(:move_icon_to_vendor, icon_name)

        assert File.exist?(@command.vendor_version_file)
        assert_equal "0.545.0", File.read(@command.vendor_version_file).strip
      end

      test "move_icon_to_vendor copies LICENSE file if it exists" do
        icon_name = "check"
        FileUtils.mkdir_p(@command.tmp_icons_dir)
        File.write(File.join(@command.tmp_icons_dir, "#{icon_name}.svg"), "<svg></svg>")
        File.write(File.join(@command.tmp_icons_dir, "LICENSE"), "MIT License")

        @command.send(:move_icon_to_vendor, icon_name)

        license_path = File.join(@command.vendor_icons_dir, "LICENSE")
        assert File.exist?(license_path)
        assert_equal "MIT License", File.read(license_path)
      end

      test "move_icon_to_vendor exits with error when icon not found" do
        assert_output(/❌ Icon 'nonexistent' not found/) do
          assert_raises(SystemExit) do
            @command.send(:move_icon_to_vendor, "nonexistent")
          end
        end
      end

      test "list_available_icons lists icons in sorted order" do
        FileUtils.mkdir_p(@command.tmp_icons_dir)
        %w[zebra apple banana].each do |icon|
          File.write(File.join(@command.tmp_icons_dir, "#{icon}.svg"), "<svg></svg>")
        end

        output = StringIO.new
        original_stdout = $stdout
        $stdout = output
        begin
          @command.send(:list_available_icons)
        ensure
          $stdout = original_stdout
        end

        output_string = output.string
        assert_match(/apple/, output_string)
        assert_match(/banana/, output_string)
        assert_match(/zebra/, output_string)
      end

      test "ensure_tmp_extracted uses existing extracted version if available" do
        FileUtils.mkdir_p(@quiet_command.tmp_icons_dir)
        File.write(File.join(@quiet_command.tmp_icons_dir, "check.svg"), "<svg></svg>")
        File.write(@quiet_command.tmp_version_file, "0.545.0")

        download_called = false
        @quiet_command.stub(:download_and_extract, ->(_) { download_called = true }) do
          @quiet_command.send(:ensure_tmp_extracted)
        end
        assert_equal false, download_called
      end

      test "ensure_tmp_extracted uses vendor version if tmp not extracted" do
        FileUtils.mkdir_p(File.dirname(@quiet_command.vendor_version_file))
        File.write(@quiet_command.vendor_version_file, "0.550.0")

        download_version = nil
        @quiet_command.stub(:download_and_extract, ->(version) { download_version = version }) do
          @quiet_command.send(:ensure_tmp_extracted)
        end
        assert_equal "0.550.0", download_version
      end

      test "ensure_tmp_extracted uses default version if no version found" do
        download_version = nil
        @quiet_command.stub(:download_and_extract, ->(version) { download_version = version }) do
          @quiet_command.send(:ensure_tmp_extracted)
        end
        assert_equal Icons::DEFAULT_VERSION, download_version
      end

      test "show_usage displays usage information" do
        output = StringIO.new
        original_stdout = $stdout
        $stdout = output
        begin
          @command.show_usage
        ensure
          $stdout = original_stdout
        end

        output_string = output.string
        assert_match(/Usage:/, output_string)
        assert_match(/bin\/icons import ICON_NAME/, output_string)
        assert_match(/bin\/icons upgrade VERSION/, output_string)
        assert_match(/Examples:/, output_string)
      end

      test "quiet mode suppresses output" do
        quiet_command = Icons.new(base_dir: @base_dir, quiet: true)
        output = StringIO.new
        original_stdout = $stdout
        $stdout = output
        begin
          quiet_command.show_usage
        ensure
          $stdout = original_stdout
        end

        assert_equal "", output.string
      end

      test "quiet mode suppresses import messages" do
        quiet_command = Icons.new(base_dir: @base_dir, quiet: true)
        FileUtils.mkdir_p(quiet_command.tmp_icons_dir)
        File.write(File.join(quiet_command.tmp_icons_dir, "check.svg"), "<svg></svg>")
        File.write(quiet_command.tmp_version_file, "0.545.0")

        output = StringIO.new
        original_stdout = $stdout
        $stdout = output
        begin
          quiet_command.stub(:ensure_tmp_extracted, -> { }) do
            quiet_command.stub(:move_icon_to_vendor, ->(_) { }) do
              quiet_command.import_icon("check")
            end
          end
        ensure
          $stdout = original_stdout
        end

        assert_equal "", output.string
      end

      test "default behavior shows output" do
        non_quiet_command = Icons.new(base_dir: @base_dir, quiet: false)
        output = StringIO.new
        original_stdout = $stdout
        $stdout = output
        begin
          non_quiet_command.show_usage
        ensure
          $stdout = original_stdout
        end

        assert_not_equal "", output.string
      end
    end
  end
end
