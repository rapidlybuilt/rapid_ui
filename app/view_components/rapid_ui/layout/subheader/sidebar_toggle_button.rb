module RapidUI
  module Layout
    module Subheader
      class SidebarToggleButton < Button
        attr_accessor :icon
        attr_accessor :title

        attr_accessor :closed
        alias_method :closed?, :closed

        def initialize
          super(
            nil,
            icon: "menu",
            title: t(".title"),
            class: "btn btn-outline-primary btn-circular size-8",
            data: {
              action: "click->sidebar#toggle",
              sidebar_target: "toggle",
            },
          )

          @closed = false
        end

        def css_class
          css = super
          css += " on" unless closed?
          css
        end
      end
    end
  end
end
