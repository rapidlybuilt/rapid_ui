module RapidUI
  module Layout
    module Sidebar
      module Navigation
        class Base < ApplicationComponent
          renders_many_polymorphic(:items,
            link: ->(*args, **kwargs) {
              build(Link, *args, **kwargs, class: merge_classes("sidebar-link sidebar-nav-link", kwargs[:class]))
            },
            section: Section,
          )

          def initialize(tag_name: :nav, **kwargs)
            super(tag_name:, **kwargs, class: merge_classes("sidebar-nav", kwargs[:class]))
          end

          def call
            component_tag { safe_join(items) }
          end
        end
      end
    end
  end
end
