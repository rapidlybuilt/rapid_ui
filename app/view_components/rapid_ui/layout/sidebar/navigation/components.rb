module RapidUI
  module Layout
    module Sidebar
      module Navigation
        class Components < RapidUI::Components
          contains :link, ->(*args, **kwargs, &block) do
            Link.new(*args, **kwargs, class: merge_classes("sidebar-link sidebar-nav-link", kwargs[:class]), &block)
          end

          contains :section, Section

          def initialize(tag_name: :nav, **kwargs, &block)
            super(tag_name:, **kwargs, class: merge_classes("sidebar-nav", kwargs[:class]), &block)
          end
        end
      end
    end
  end
end
