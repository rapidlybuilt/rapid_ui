module RapidUI
  class Config
    class ImportmapConfig
      attr_accessor :watches

      def initialize
        @watches = []
      end
    end

    attr_reader :importmap
    attr_accessor :icon_paths

    def initialize
      @importmap = ImportmapConfig.new
      @icon_paths = [
        RapidUI.root.join("vendor/lucide_icons"),
      ]
    end
  end
end
