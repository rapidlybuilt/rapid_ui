require "optparse"
require "fileutils"

module RapidUI
  module Commands
    class TailwindCSS
      DEFAULT_TARGET = :main
      TEMP_DIR = "tmp/tailwindcss"
      GEM_ROOT = File.expand_path("../../../..", __FILE__)

      attr_reader :configs

      def initialize(configs)
        @configs = configs
      end

      def run(args)
        options = parse_options(args)
        command = args[0]
        target = normalize_target(options[:target])

        execute(command, target)
      end

      def execute(command, target = nil)
        case command
        when "build"
          prepare_imports(target)
          run_command(build_command(target))
        when "watch"
          prepare_imports(target)
          run_command(watch_command(target))
        when "clean"
          run_command(clean_command(target))
        when "help", "--help", "-h"
          show_help
        when nil
          puts "Error: No command specified"
          puts
          show_help
          exit 1
        else
          puts "Error: Unknown command '#{command}'"
          puts
          show_help
          exit 1
        end
      end

      def build_command(target = nil)
        config = get_config(target)
        input = effective_input(target, config)
        "bundle exec tailwindcss -i #{input} -o #{config[:output]}"
      end

      def watch_command(target = nil)
        config = get_config(target)
        input = effective_input(target, config)
        "bundle exec tailwindcss -i #{input} -o #{config[:output]} --watch"
      end

      def clean_command(target = nil)
        config = get_config(target)
        "rm -rf #{config[:build_dir]}"
      end

      def show_help
        target_names = configs.keys.compact.map { |k| "'#{k}'" }.join(", ")

        puts <<~HELP
          Usage: bin/tailwindcss [COMMAND] [--target TARGET]

          Commands:
            build    Build Tailwind CSS once
            watch    Build Tailwind CSS and watch for changes
            clean    Remove the build artifact
            help     Show this help message

          Options:
            --target TARGET    Choose target: #{target_names} (default: main library)

          Examples:
            bin/tailwindcss build
            bin/tailwindcss watch
            bin/tailwindcss build --target docs
            bin/tailwindcss watch --target docs
            bin/tailwindcss clean
        HELP
      end

      private

      def get_config(target)
        config = configs[target] || (configs[nil] if target == DEFAULT_TARGET)
        raise ArgumentError, "Unknown target: #{target.inspect}" unless config
        config
      end

      def has_imports?(config)
        config[:import].is_a?(Array) && config[:import].any?
      end

      def temp_file_name(target)
        "#{target}.css"
      end

      def temp_file_path(target)
        File.join(TEMP_DIR, temp_file_name(target))
      end

      def effective_input(target, config)
        has_imports?(config) ? temp_file_path(target) : config[:input]
      end

      def prepare_imports(target)
        config = get_config(target)
        return unless has_imports?(config)

        FileUtils.mkdir_p(TEMP_DIR)

        original_input = File.expand_path(config[:input])
        imports = config[:import]

        content = imports.map { |path| "@import \"#{resolve_import_path(path)}\";" }.join("\n")
        content += "\n@import \"#{original_input}\";\n"

        File.write(temp_file_path(target), content)
        puts "Created temporary import file: #{temp_file_path(target)}"
      end

      def resolve_import_path(path)
        self.class.resolve_import_path(path)
      end

      def normalize_target(target)
        return DEFAULT_TARGET if target.nil?

        # Try the target as-is first
        return target.to_sym if configs.key?(target.to_sym)

        # Try lowercase symbol
        normalized = target.to_s.downcase.to_sym
        return normalized if configs.key?(normalized)

        # Return as symbol, let get_config raise if invalid
        normalized
      end

      def parse_options(args)
        options = {}
        OptionParser.new do |opts|
          opts.banner = "Usage: bin/tailwindcss [COMMAND] [options]"

          opts.on("--target TARGET", "Choose target") do |target|
            options[:target] = target
          end

          opts.on("-h", "--help", "Show this help message") do
            show_help
            exit
          end
        end.parse!(args)
        options
      end

      def run_command(command)
        puts "Running: #{command}"
        system(command)
      end

      class << self
        # HACK: this is a hack to allow imports from libraries without having to use sprockets or npm.
        def import_paths
          @import_paths ||= {
            "rapid_ui" => File.join(GEM_ROOT, "app/assets/stylesheets"),
          }
        end

        def register_import_path(prefix, base_path)
          import_paths[prefix] = base_path
        end

        def resolve_import_path(path)
          import_paths.each do |prefix, base_path|
            if path.start_with?("#{prefix}/")
              return File.join(base_path, "#{path}.css")
            end
          end
          path
        end
      end
    end
  end
end
