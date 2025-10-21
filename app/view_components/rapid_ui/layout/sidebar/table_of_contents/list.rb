module RapidUI
  module Layout
    module Sidebar
      module TableOfContents
        class List < RapidUI::Components
          attr_accessor :depth

          contains :link, ->(*args, **kwargs, &block) do
            build(Link, *args, **kwargs, class: merge_classes("sidebar-link", kwargs[:class]), &block)
          end

          contains :list, ->(*args, **kwargs, &block) do
            build(self.class, *args, depth: depth + 1, **kwargs, &block)
          end

          def initialize(*args, depth: 0, **kwargs)
            super(*args, tag_name: :ul, **kwargs, class: merge_classes("sidebar-toc-list", kwargs[:class]))

            @depth = depth

            yield self if block_given?
          end

          def dynamic_css_class
            merge_classes(super, "sidebar-toc-list-depth-#{depth}")
          end
        end
      end
    end
  end
end
