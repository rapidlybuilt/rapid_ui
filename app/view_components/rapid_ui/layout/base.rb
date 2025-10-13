module RapidUI
  module Layout
    class Base < ApplicationComponent
      attr_accessor :head

      def initialize
        @head = Head.new
      end

      class << self
        def layout_template
          raise NotImplementedError
        end
      end
    end
  end
end
