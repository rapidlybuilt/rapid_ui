module RapidUI
  module Layout
    module Subheader
      class SidebarToggleButton < Button
        attr_accessor :icon
        attr_accessor :title

        attr_accessor :closed
        alias_method :closed?, :closed

        def initialize(**kwargs, &block)
          @closed = false

          super(
            children: Icon.new("menu"),
            title: t(".title"),
            variant: "outline-primary",
            class: "btn-circular size-8",
            data: {
              action: "click->sidebar#toggle",
              sidebar_target: "toggle",
            },
            **kwargs,
            &block
          )
        end

        def dynamic_css_class
          combine_classes(
            ("on" unless closed?),
            super,
          )
        end
      end
    end
  end
end
