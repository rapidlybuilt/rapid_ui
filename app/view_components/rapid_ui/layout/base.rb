module RapidUI
  module Layout
    class Base < ApplicationComponent
      renders_one :head

      def initialize(**kwargs, &block)
        self.head = Head::Base.new

        super(**kwargs, &block)
      end

      def layout_content
        # HACK: unsure why content is being set like this
        view_context.capture(&content?) if content?.is_a?(Proc)
      end

      class << self
        def layout_template
          "rapid_ui/application"
        end
      end
    end
  end
end
