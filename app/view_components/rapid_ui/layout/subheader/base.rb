module RapidUI
  module Layout
    module Subheader
      class Base < ApplicationComponent
        attr_accessor :sidebar_toggle_button
        attr_accessor :breadcrumbs
        attr_accessor :buttons

        def initialize(**kwargs)
          super(**kwargs)

          @sidebar_toggle_button = SidebarToggleButton.new
          @breadcrumbs = Breadcrumbs.new(separator: " &raquo; ".html_safe)
          @buttons = Buttons.new
        end

        class Breadcrumbs < Components
          contains Breadcrumb, nil
        end

        class Buttons < Components
          contains Button, nil do |icon, path, variant: "naked", **kwargs|
            icon = Icon.new(icon)
            Button.new(children: icon, path:, variant:, additional_class: "subheader-btn", **kwargs)
          end
        end
      end
    end
  end
end
