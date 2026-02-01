require "net/http"
require "openssl"
require "uri"
require "zip"
require "fileutils"

module RapidUI
  module Commands
    class Icons
      DEFAULT_VERSION = "0.545.0"

      attr_reader :base_dir

      def initialize(base_dir:)
        @base_dir = base_dir
      end

      def tmp_dir
        File.join(base_dir, "tmp")
      end

      def vendor_dir
        File.join(base_dir, "vendor")
      end

      def tmp_icons_dir
        File.join(tmp_dir, "lucide-icons")
      end

      def vendor_icons_dir
        File.join(vendor_dir, "lucide_icons")
      end

      def tmp_version_file
        File.join(tmp_icons_dir, "VERSION")
      end

      def vendor_version_file
        File.join(vendor_icons_dir, "VERSION")
      end

      def run(args)
        if args.length < 2
          puts "❌ Not enough arguments"
          show_usage
          exit 1
        end

        action = args[0]
        arg = args[1]

        case action
        when "import"
          import_icon(arg)
        when "upgrade"
          upgrade_version(arg)
        else
          puts "❌ Unknown action: #{action}"
          show_usage
          exit 1
        end
      end

      def import_icon(icon_name)
        if icon_name.nil? || icon_name.empty?
          puts "❌ Please provide an icon name"
          show_usage
          exit 1
        end

        puts "Importing icon: #{icon_name}"

        ensure_tmp_extracted
        move_icon_to_vendor(icon_name)
        puts "✅ Successfully imported #{icon_name}.svg"
      end

      def upgrade_version(new_version)
        if new_version.nil? || new_version.empty?
          puts "❌ Please provide a version number"
          show_usage
          exit 1
        end

        puts "🔄 Upgrading Lucide icons to version #{new_version}"

        # Get list of currently imported icons (excluding VERSION and LICENSE)
        current_icons = []
        if Dir.exist?(vendor_icons_dir)
          current_icons = Dir.glob(File.join(vendor_icons_dir, "*.svg")).map { |f| File.basename(f, ".svg") }
          puts "📋 Found #{current_icons.length} icons to update"
        end

        # Download and extract new version
        download_and_extract(new_version)

        # Clear vendor directory
        FileUtils.rm_rf(vendor_icons_dir) if Dir.exist?(vendor_icons_dir)
        FileUtils.mkdir_p(vendor_icons_dir)

        # Write new version file
        File.write(vendor_version_file, new_version)
        puts "📝 Updated VERSION to #{new_version}"

        # Copy LICENSE
        license_source = File.join(tmp_icons_dir, "LICENSE")
        license_target = File.join(vendor_icons_dir, "LICENSE")
        FileUtils.cp(license_source, license_target) if File.exist?(license_source)

        # Re-import all icons
        if current_icons.any?
          puts "🔄 Re-importing #{current_icons.length} icons..."
          current_icons.each do |icon_name|
            icon_path = find_icon_in_extracted(icon_name)
            if icon_path
              target_path = File.join(vendor_icons_dir, "#{icon_name}.svg")
              FileUtils.cp(icon_path, target_path)
              puts "  ✓ #{icon_name}"
            else
              puts "  ⚠️  #{icon_name} not found in new version"
            end
          end
        end

        puts "✅ Successfully upgraded to version #{new_version}"
      end

      def show_usage
        puts "\nUsage:"
        puts "  bin/icons import ICON_NAME     Import a single icon"
        puts "  bin/icons upgrade VERSION      Upgrade all icons to a new version"
        puts "\nExamples:"
        puts "  bin/icons import chevron-down"
        puts "  bin/icons upgrade 0.550.0"
      end

      private

      def ensure_tmp_extracted
        # Check if the extraction directory exists and has SVG files
        if Dir.exist?(tmp_icons_dir) && Dir.glob(File.join(tmp_icons_dir, "*.svg")).any?
          version = current_tmp_version
          puts "📁 Lucide icons v#{version} already extracted in tmp/lucide-icons/"
          return
        end

        # If vendor directory exists, use its version
        version = current_vendor_version
        if version.nil?
          version = DEFAULT_VERSION
          puts "ℹ️  No version found, using default version #{version}"
        end

        puts "📥 Downloading Lucide icons v#{version}..."
        download_and_extract(version)
      end

      def download_and_extract(version)
        url = "https://github.com/lucide-icons/lucide/releases/download/#{version}/lucide-icons-#{version}.zip"
        zip_path = File.join(tmp_dir, "lucide-#{version}.zip")

        # Ensure tmp directory exists
        FileUtils.mkdir_p(tmp_dir)

        # Download the zip file
        download_file(url, zip_path)

        # Clear and recreate tmp directory
        FileUtils.rm_rf(tmp_icons_dir) if Dir.exist?(tmp_icons_dir)
        FileUtils.mkdir_p(tmp_icons_dir)

        # Extract the zip file
        puts "📦 Extracting icons..."
        extract_zip(zip_path, version)

        # Write version file
        File.write(tmp_version_file, version)

        # Clean up the zip file
        File.delete(zip_path) if File.exist?(zip_path)

        puts "✅ Icons v#{version} extracted to #{tmp_icons_dir}"
      end

      def download_file(url, destination)
        uri = URI(url)

        # HACK: disable SSL verification. Ruby 3.4 enables CRL checking by default, which causes problems.
        Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https", verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|
          request = Net::HTTP::Get.new(uri)

          http.request(request) do |response|
            case response.code
            when "200"
              File.open(destination, "wb") do |file|
                response.read_body do |chunk|
                  file.write(chunk)
                end
              end
            when "302", "301"
              # Follow redirect
              redirect_url = response["location"]
              puts "🔄 Following redirect to: #{redirect_url}"
              download_file(redirect_url, destination)
            else
              raise "Failed to download: #{response.code} #{response.message}"
            end
          end
        end
      end

      def extract_zip(zip_path, version)
        Zip::File.open(zip_path) do |zip_file|
          zip_file.each do |entry|
            # Extract only the icons directory and LICENSE
            if entry.name.include?("icons/") && (entry.name.end_with?(".svg") || entry.name.end_with?("LICENSE"))
              # Create the target path
              relative_path = entry.name.gsub(/^[^\/]+\//, "") # Remove the root directory name
              target_path = File.join(tmp_icons_dir, File.dirname(relative_path))

              # Create directory if it doesn't exist
              FileUtils.mkdir_p(target_path) unless Dir.exist?(target_path)

              # Extract the file
              entry.extract(File.join(tmp_icons_dir, relative_path)) { true } # Overwrite if exists
            end
          end
        end
      end

      def move_icon_to_vendor(icon_name)
        # Ensure vendor directory exists
        FileUtils.mkdir_p(vendor_icons_dir) unless Dir.exist?(vendor_icons_dir)

        # Copy version file from tmp to vendor if it doesn't exist
        if File.exist?(tmp_version_file) && !File.exist?(vendor_version_file)
          FileUtils.cp(tmp_version_file, vendor_version_file)
        end

        # Find the icon in the extracted directory
        icon_path = find_icon_in_extracted(icon_name)

        if icon_path.nil?
          puts "❌ Icon '#{icon_name}' not found in Lucide icons"
          puts "💡 Available icons:"
          list_available_icons
          exit 1
        end

        # Copy the icon to vendor directory
        target_path = File.join(vendor_icons_dir, "#{icon_name}.svg")
        FileUtils.cp(icon_path, target_path)

        # Also copy LICENSE if it doesn't exist
        license_source = File.join(tmp_icons_dir, "LICENSE")
        license_target = File.join(vendor_icons_dir, "LICENSE")
        FileUtils.cp(license_source, license_target) if File.exist?(license_source) && !File.exist?(license_target)
      end

      def find_icon_in_extracted(icon_name)
        # Look for the icon file directly in tmp directory
        icon_file = File.join(tmp_icons_dir, "#{icon_name}.svg")
        return icon_file if File.exist?(icon_file)

        # Try with kebab-case conversion
        kebab_name = icon_name.gsub(/([A-Z])/, '-\1').downcase.gsub(/^-/, "")
        kebab_file = File.join(tmp_icons_dir, "#{kebab_name}.svg")
        return kebab_file if File.exist?(kebab_file)

        nil
      end

      def list_available_icons
        icons = Dir.glob(File.join(tmp_icons_dir, "*.svg")).map { |f| File.basename(f, ".svg") }
        icons.sort.each_slice(4) do |row|
          puts "   #{row.map { |icon| icon.ljust(20) }.join}"
        end
      end

      def current_tmp_version
        return File.read(tmp_version_file).strip if File.exist?(tmp_version_file)
        nil
      end

      def current_vendor_version
        return File.read(vendor_version_file).strip if File.exist?(vendor_version_file)
        nil
      end
    end
  end
end
