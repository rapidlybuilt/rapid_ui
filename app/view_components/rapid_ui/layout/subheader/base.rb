module RapidUI
  module Layout
    module Subheader
      class Base < ApplicationComponent
        attr_accessor :sidebar_toggle_button
        attr_accessor :breadcrumbs
        attr_accessor :buttons

        def initialize(**kwargs, &block)
          @sidebar_toggle_button = SidebarToggleButton.new

          # HACK: don't manually generate this HTML separator
          @breadcrumbs = Breadcrumbs.new(separator: %(<span class="px-3px">&raquo;</span>).html_safe)
          @buttons = Buttons.new

          super(**kwargs, &block)
        end

        class Breadcrumbs < Components
          contains Breadcrumb, nil
        end

        class Buttons < Components
          contains Button, nil do |icon, path, variant: "naked", **kwargs, &block|
            icon = Icon.new(icon)
            Button.new(children: icon, path:, variant:, additional_class: "subheader-btn", **kwargs, &block)
          end
        end
      end
    end
  end
end
