module RapidUI
  module Layout
    module Sidebar
      module Navigation
        class Section < ApplicationComponent
          # HACK: is this really how we want to share component builders?
          BUILD_LINK = ->(*args, **kwargs) {
            build(
              Link,
              *args,
              **kwargs,
              class: merge_classes("sidebar-link sidebar-nav-link", kwargs[:class]),
              data: merge_data({
                # ensure the sidebar is closed if they navigate back to this page
                action: "click->sidebar#closeUnlessLarge",
              }, kwargs[:data]),
            )
          }

          attr_accessor :name
          attr_accessor :path
          attr_accessor :expanded
          alias_method :expanded?, :expanded

          renders_one :button, ->(name, path: self.path, **kwargs) do
            build(
              Button,
              build(Icon, "chevron-down", class: "expandable-chevron"),
              build(Tag).with_content(name),
              path:,
              **kwargs,
              class: merge_classes("sidebar-section-toggle", kwargs[:class]),
              data: merge_data({
                action: "click->expandable#toggle",
              }, kwargs[:data]),
            )
          end

          # TODO: convert this to a non-polymorphic block
          renders_many_polymorphic(:links, skip_tags: true,
            link: BUILD_LINK,
          )

          def initialize(name, path = nil, expanded: nil, **kwargs)
            super(**kwargs)

            @name = name
            @path = path
            @expanded = expanded
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

          def before_render
            with_button(name) unless button?
            super
          end
        end
      end
    end
  end
end
