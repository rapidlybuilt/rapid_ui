module RapidUI
  module Layout
    module Sidebar
      module TableOfContents
        class List < ApplicationComponent
          attr_accessor :depth

          renders_many_polymorphic(:items,
            link: ->(*args, **kwargs) {
              build(Link, *args, **kwargs, class: merge_classes("sidebar-link", kwargs[:class]))
            },
            list: ->(*args, **kwargs) {
              build(self.class, *args, depth: depth + 1, **kwargs)
            },
          )

          def initialize(*args, depth: 0, **kwargs)
            super(*args, tag_name: :ul, **kwargs, class: merge_classes("sidebar-toc-list", kwargs[:class]))

            @depth = depth
          end

          def dynamic_css_class
            merge_classes(super, "sidebar-toc-list-depth-#{depth}")
          end

          def call
            component_tag do
              safe_join(items.map { |i| tag.li(i) })
            end
          end
        end
      end
    end
  end
end
