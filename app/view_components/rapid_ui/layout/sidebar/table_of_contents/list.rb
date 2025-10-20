module RapidUI
  module Layout
    module Sidebar
      module TableOfContents
        class List < RapidUI::Components
          attr_accessor :depth

          contains :link do |*args, **kwargs, &block|
            Link.new(*args, **kwargs, class: merge_classes("sidebar-link", kwargs[:class]), &block)
          end

          contains :list do |*args, **kwargs, &block|
            self.class.new(*args, depth: depth + 1, **kwargs, &block)
          end

          def initialize(*args, depth: 0, **kwargs, &block)
            @depth = depth

            super(*args, tag_name: :ul, **kwargs, class: merge_classes("sidebar-toc-list", kwargs[:class]), &block)
          end

          def dynamic_css_class
            merge_classes(super, "sidebar-toc-list-depth-#{depth}")
          end
        end
      end
    end
  end
end
