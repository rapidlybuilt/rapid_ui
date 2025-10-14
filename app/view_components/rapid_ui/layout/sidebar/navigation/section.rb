module RapidUI
  module Layout
    module Sidebar
      module Navigation
        class Section < ApplicationComponent
          attr_accessor :button
          attr_accessor :contents

          attr_writer :expanded

          with_options to: :contents do
            delegate :build_link
          end

          def initialize(name, expanded: nil, **kwargs)
            super(**kwargs)

            @expanded = expanded
            @contents = Components.new

            @button = Button.new(
              children: Components.new([
                Icon.new("chevron-down", class: "expandable-chevron"),
                Text.new(name)
              ]),
              class: "sidebar-section-toggle",
              data: {
                action: "click->expandable#toggle",
              },
            )
          end

          def collapsed?
            @expanded.nil? ? !any_active_links? : @expanded
          end

          def dynamic_css_class
            combine_classes(
              "sidebar-section",
              ("collapsed" if collapsed?),
              super,
            )
          end

          private

          def any_active_links?
            contents.any?(&:active?)
          end

          class Components < Components
            contains Link, :link
          end
        end
      end
    end
  end
end
