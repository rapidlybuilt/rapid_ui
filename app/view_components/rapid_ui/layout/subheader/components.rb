module RapidUI
  module Layout
    module Subheader
      class Components < RapidUI::Components
        contains Breadcrumb::Components, :breadcrumbs

        contains Button, :button do |icon, path, variant: "naked", **kwargs, &block|
          Button.new(Icon.new(icon), path:, variant:, additional_class: "subheader-btn", **kwargs, &block)
        end

        contains :sidebar_toggle_button do |target:, icon:, circular: false, **kwargs, &block|
          ToggleButton.new(
            Icon.new(icon),
            title: t(".sidebar_toggle_button.title"),
            on_class: "btn-outline-primary",
            off_class: "btn-naked",
            target:,
            class: (circular ? "btn btn-circular size-8" : "btn"),
            # TODO: smarter merge
            data: (kwargs.delete(:data) || {}).merge(
              controller: "toggle-button",
              action: "click->toggle-button#toggle",
            ),
            **kwargs,
            &block
          )
        end
      end
    end
  end
end
