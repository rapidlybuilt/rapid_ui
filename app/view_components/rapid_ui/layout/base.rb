module RapidUI
  module Layout
    class Base < ApplicationComponent
      renders_one :head, Head::Base

      def initialize(**kwargs)
        super(**kwargs)

        yield self if block_given?
      end

      def layout_content_block
        # HACK: calling with_* methods to set the slots by default screws up the content block
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
