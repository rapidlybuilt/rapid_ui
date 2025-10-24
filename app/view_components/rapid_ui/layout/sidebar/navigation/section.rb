module RapidUI
  module Layout
    module Sidebar
      module Navigation
        class Section < ApplicationComponent
          attr_accessor :name
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

          renders_many_polymorphic(:children,
            link: ->(*args, **kwargs, &block) {
              build(Link, *args, **kwargs, class: merge_classes("sidebar-link sidebar-nav-link", kwargs[:class]), &block)
            },
          )

          with_options to: :button do
            delegate :path
            delegate :path=
          end

          def initialize(name, expanded: nil, **kwargs)
            super(**kwargs)

            @name = name
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

          def before_render
            with_button(name) unless button?
            super
          end
        end
      end
    end
  end
end
