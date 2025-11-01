module RapidUI
  class Config
    class ImportmapConfig
      attr_accessor :watches

      def initialize
        @watches = []
      end
    end

    attr_reader :importmap

    def initialize
      @importmap = ImportmapConfig.new
    end
  end
end
