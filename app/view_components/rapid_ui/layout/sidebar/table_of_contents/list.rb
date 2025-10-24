module RapidUI
  module Layout
    module Sidebar
      module TableOfContents
        class List < ApplicationComponent
          attr_accessor :depth

          renders_many_polymorphic(:items,
            link: ->(*args, **kwargs, &block) {
              build(Link, *args, **kwargs, class: merge_classes("sidebar-link", kwargs[:class]), &block)
            },
            list: ->(*args, **kwargs, &block) {
              build(self.class, *args, depth: depth + 1, **kwargs, &block)
            },
          )

          def initialize(*args, depth: 0, **kwargs)
            super(*args, tag_name: :ul, **kwargs, class: merge_classes("sidebar-toc-list", kwargs[:class]))

            @depth = depth

            yield self if block_given?
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
