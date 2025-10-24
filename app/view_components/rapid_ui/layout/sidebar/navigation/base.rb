module RapidUI
  module Layout
    module Sidebar
      module Navigation
        class Base < ApplicationComponent
          renders_many_polymorphic(:items,
            link: ->(*args, **kwargs, &block) {
              build(Link, *args, **kwargs, class: merge_classes("sidebar-link sidebar-nav-link", kwargs[:class]), &block)
            },
            section: Section,
          )

          def initialize(tag_name: :nav, **kwargs, &block)
            super(tag_name:, **kwargs, class: merge_classes("sidebar-nav", kwargs[:class]), &block)
          end

          def call
            component_tag { safe_join(items) }
          end
        end
      end
    end
  end
end
