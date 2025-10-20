module RapidUI
  module Layout
    module Sidebar
      module Navigation
        class Section < ApplicationComponent
          attr_writer :expanded

          renders_one :button, ->(name, **kwargs, &block) do
            Button.new(
              Icon.new("chevron-down", class: "expandable-chevron"),
              Text.new(name),
              class: "sidebar-section-toggle",
              data: {
                action: "click->expandable#toggle",
              },
            )
          end

          renders_one :components, "Components"

          with_options to: :components do
            delegate :with_link
          end

          def initialize(name, expanded: nil, **kwargs)
            with_button(name)
            with_components

            @expanded = expanded

            super(**kwargs)
          end

          def collapsed?
            @expanded.nil? ? !any_active_links? : @expanded
          end

          def dynamic_css_class
            merge_classes(
              "sidebar-section",
              ("collapsed" if collapsed?),
              super,
            )
          end

          private

          def any_active_links?
            components.any?(&:active?)
          end

          class Components < Components
            contains :link, Link
          end
        end
      end
    end
  end
end
