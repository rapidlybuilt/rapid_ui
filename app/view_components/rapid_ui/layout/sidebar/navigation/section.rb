module RapidUI
  module Layout
    module Sidebar
      module Navigation
        class Section < ApplicationComponent
          attr_accessor :button
          attr_accessor :contents

          attr_writer :expanded
          attr_writer :css_class

          with_options to: :contents do
            delegate :build_link
          end

          def initialize(name, expanded: nil, **kwargs)
            @expanded = expanded
            @contents = Components.new
            @css_class = combine_classes("sidebar-section", kwargs[:class])

            @button = Button.new(
              name,
              icon: "chevron-right",
              class: "sidebar-section-toggle",
              data: {
                action: "click->collapsible#toggle",
              },
            )
            @button.icon.css_class = "collapsible-icon"
          end

          def expanded?
            @expanded.nil? ? any_active_links? : @expanded
          end

          def css_class
            css = @css_class || ""
            css += " expanded" if expanded?
            css
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
