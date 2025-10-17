module RapidUI
  module Layout
    module Sidebar
      module Navigation
        class Base < RapidUI::Components
          contains Link, :link
          contains Section, :section

          def initialize(tag_name: :nav, **kwargs, &block)
            super(tag_name:, additional_class: "sidebar-nav", **kwargs, &block)
          end

          def call
            component_tag(super)
          end
        end
      end
    end
  end
end
