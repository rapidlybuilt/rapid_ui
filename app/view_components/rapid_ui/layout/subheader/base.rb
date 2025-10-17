module RapidUI
  module Layout
    module Subheader
      class Base < ApplicationComponent
        renders_one :breadcrumbs, "Breadcrumbs"
        renders_one :buttons, "Buttons"

        renders_one :sidebar_toggle_button, ->(target_id, **kwargs, &block) do
          ToggleButton.new(
            Icon.new("menu"),
            title: t(".sidebar_toggle_button.title"),
            variant: "outline-primary",
            class: "btn-circular size-8",
            # TODO: smarter merge
            data: (kwargs.delete(:data) || {}).merge(
              controller: "toggle-button",
              action: "click->toggle-button#toggle",
              toggle_button_target_value: target_id,
              toggle_button_on_class: "btn-outline-primary",
              toggle_button_off_class: "btn-naked",
            ),
            **kwargs,
            &block
          )
        end

        def initialize(**kwargs, &block)
          with_breadcrumbs
          with_buttons
          with_sidebar_toggle_button("main_sidebar")

          super(**kwargs, &block)
        end

        class Breadcrumbs < Components
          # HACK: don't manually generate this HTML separator
          Separator = %(<span class="px-3px">&raquo;</span>).html_safe.freeze

          contains Breadcrumb, nil

          def initialize(separator: Separator, **kwargs, &block)
            super(separator:, **kwargs, &block)
          end
        end

        class Buttons < Components
          contains Button, nil do |icon, path, variant: "naked", **kwargs, &block|
            Button.new(Icon.new(icon), path:, variant:, additional_class: "subheader-btn", **kwargs, &block)
          end
        end
      end
    end
  end
end
