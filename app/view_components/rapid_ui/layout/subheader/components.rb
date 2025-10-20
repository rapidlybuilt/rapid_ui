module RapidUI
  module Layout
    module Subheader
      class Components < RapidUI::Components
        contains :breadcrumbs, Breadcrumb::Components

        contains :button do |icon, path, variant: "naked", **kwargs, &block|
          Button.new(Icon.new(icon), path:, variant:, **kwargs, class: merge_classes("subheader-btn", kwargs[:class]), &block)
        end

        contains :sidebar_toggle_button do |target:, icon:, circular: false, **kwargs, &block|
          ToggleButton.new(
            Icon.new(icon),
            title: t(".sidebar_toggle_button.title"),
            on_class: "btn-outline-primary",
            off_class: "btn-naked",
            target:,
            **kwargs,
            class: merge_classes(circular ? "btn btn-circular size-8" : "btn", kwargs[:class]),
            data: merge_data({
              controller: "toggle-button",
              action: "click->toggle-button#toggle",
            }, kwargs[:data]),
            &block
          )
        end
      end
    end
  end
end
