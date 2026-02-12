module RapidUI
  module Commands
    class Base
      attr_reader :quiet

      def initialize(quiet: false)
        @quiet = quiet
      end

      private

      def output(message)
        puts message unless quiet
      end
    end
  end
end
