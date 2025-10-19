module RapidUI
  module Layout
    module Sidebar
      module Navigation
        class Components < RapidUI::Components
          contains :link do |*args, **kwargs, &block|
            Link.new(*args, additional_class: "sidebar-link sidebar-nav-link", **kwargs, &block)
          end

          contains :section, Section

          def initialize(tag_name: :nav, **kwargs, &block)
            super(tag_name:, additional_class: "sidebar-nav", **kwargs, &block)
          end
        end
      end
    end
  end
end
