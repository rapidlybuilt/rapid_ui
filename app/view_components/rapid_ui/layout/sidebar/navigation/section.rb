module RapidUI
  module Layout
    module Sidebar
      module Navigation
        class Section < ApplicationComponent
          attr_accessor :expanded
          alias_method :expanded?, :expanded

          renders_one :button, ->(name, **kwargs, &block) do
            build(
              Button,
              build(Icon, "chevron-down", class: "expandable-chevron"),
              build(Tag).with_content(name),
              **kwargs,
              class: merge_classes("sidebar-section-toggle", kwargs[:class]),
              data: merge_data({
                action: "click->expandable#toggle",
              }, kwargs[:data]),
              &block
            )
          end

          renders_one :components, "Components"

          with_options to: :components do
            delegate :with_link
          end

          def initialize(name, expanded: nil, **kwargs)
            super(**kwargs)

            with_button(name)
            with_components

            @expanded = expanded

            yield self if block_given?
          end

          def collapsed?
            !expanded?
          end

          def dynamic_css_class
            merge_classes(
              "sidebar-section",
              ("collapsed" if collapsed?),
              super,
            )
          end

          class Components < Components
            contains :link, Link
          end
        end
      end
    end
  end
end
