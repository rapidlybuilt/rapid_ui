module RapidUI
  module Layout
    module Sidebar
      module TableOfContents
        class List < RapidUI::Components
          attr_accessor :depth

          contains Link, :link do |*args, **kwargs, &block|
            Link.new(*args, additional_class: "sidebar-link", **kwargs, &block)
          end

          contains self, :list do |*args, **kwargs, &block|
            List.new(*args, depth: depth + 1, **kwargs, &block)
          end

          def initialize(*args, depth: 0, **kwargs, &block)
            @depth = depth

            super(*args, tag_name: :ul, additional_class: "sidebar-toc-list", **kwargs, &block)
          end

          def dynamic_css_class
            combine_classes(super, "sidebar-toc-list-depth-#{depth}")
          end
        end
      end
    end
  end
end
