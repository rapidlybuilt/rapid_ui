module RapidUI
  module Layout
    module Subheader
      class Base < ApplicationComponent
        renders_one :sidebar_toggle_button, ->(icon:, circular: false, target: nil, **kwargs) do
          build(
            ToggleButton,
            build(Icon, icon),
            title: t(".sidebar_toggle_button.title"),
            on_class: "btn-outline-primary",
            off_class: "btn-naked",
            target:,
            **kwargs,
            class: merge_classes(circular ? "btn btn-circular size-8" : "btn", kwargs[:class]),
          )
        end

        renders_one :breadcrumbs, Breadcrumb::Container

        renders_many_polymorphic(:buttons,
          button: ->(icon, path, variant: "naked", **kwargs) {
            build(Button, build(Icon, icon), path:, variant:, **kwargs, class: merge_classes("subheader-btn", kwargs[:class]))
          },
          toggle_button: ->(icon:, circular: false, target: nil, **kwargs) {
            build(ToggleButton, build(Icon, icon), title: t(".sidebar_toggle_button.title"), on_class: "btn-outline-primary", off_class: "btn-naked", target:, **kwargs, class: merge_classes(circular ? "btn btn-circular size-8" : "btn", kwargs[:class]))
          },
        )

        def initialize(**kwargs)
          super(tag_name: :div, **kwargs, class: merge_classes("subheader", kwargs[:class]))
        end

        def call
          content = []
          content << sidebar_toggle_button if sidebar_toggle_button?
          content << breadcrumbs if breadcrumbs?
          content << tag.div(safe_join(buttons), class: "subheader-buttons") if buttons.any?

          component_tag { safe_join(content) }
        end
      end
    end
  end
end
