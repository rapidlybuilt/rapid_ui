module RapidUI
  module Layout
    module Subheader
      class SidebarToggle < ApplicationComponent
        attr_accessor :icon
        attr_accessor :title

        attr_accessor :closed
        alias_method :closed?, :closed

        def initialize
          @icon = Icon.new("menu")
          @title = "Toggle sidebar"
          @closed = false
        end

        def call
          css = "btn btn-outline-primary btn-circular"
          css << " on" unless closed?

          data = {
            action: "click->sidebar#toggle",
            sidebar_target: "toggle",
          }

          tag.button(render(icon), class: css, title:, data:)
        end
      end
    end
  end
end
