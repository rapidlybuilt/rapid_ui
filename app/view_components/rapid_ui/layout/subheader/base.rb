module RapidUI
  module Layout
    module Subheader
      class Base < ApplicationComponent
        renders_one :breadcrumbs, "Breadcrumbs"
        renders_one :buttons, "Buttons"

        renders_one :sidebar_toggle_button, ->(sidebar_id, **kwargs, &block) do
          ToggleButton.new(
            Icon.new("menu"),
            title: t(".sidebar_toggle_button.title"),
            variant: "outline-primary",
            class: "btn-circular size-8",
            # TODO: smarter merge
            data: (kwargs.delete(:data) || {}).merge(
              action: "click->sidebars#toggle",
              sidebars_target: "toggle",
              sidebar_toggle_on_class: "btn-outline-primary",
              sidebar_toggle_off_class: "btn-naked",
              sidebar_id:,
            ),
            **kwargs,
            &block
          )
        end

        def initialize(sidebar_id: "main", **kwargs, &block)
          @sidebar_id = sidebar_id

          with_breadcrumbs
          with_buttons

          super(**kwargs, &block)
        end

        def sidebar_id=(sidebar_id)
          @sidebar_id = sidebar_id
          with_sidebar_toggle_button(sidebar_id: sidebar_id)
        end

        def sidebar_id
          @sidebar_id
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
