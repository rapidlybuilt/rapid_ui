module RapidUI
  module Layout
    class Base < ApplicationComponent
      renders_one :head

      def initialize(**kwargs, &block)
        self.head = Head::Base.new

        super(**kwargs, &block)
      end

      def layout_content_block
        # HACK: why is `content` nil yet `content?`` is the proc with the layout content?
        content? if content?.is_a?(Proc)
      end

      class << self
        def layout_template
          "rapid_ui/application"
        end
      end
    end
  end
end
