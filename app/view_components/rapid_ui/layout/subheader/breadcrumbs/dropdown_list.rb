module RapidUI
  module Layout
    module Subheader
      module Breadcrumbs
        class DropdownList < BaseList
          renders_one :dropdown, ->(**kwargs) {
            build(Dropdown, variant: nil, **kwargs)
          }

          def call
            component_tag(dropdown)
          end

          private

          def before_render
            super
            init_dropdown if !dropdown? && any?
          end

          def init_dropdown
            with_dropdown(align: "center").tap do |dropdown|
              init_dropdown_button(dropdown)
              init_dropdown_menu(dropdown)
            end
          end

          def init_dropdown_button(dropdown)
            dropdown.with_button(build(Dropdown::ArrowIcon), array.last.name, skip_caret: true)
          end

          def init_dropdown_menu(dropdown)
            dropdown.with_menu do |menu|
              array.each do |breadcrumb|
                menu.with_item(breadcrumb.name, breadcrumb.path)
              end
            end
          end
        end
      end
    end
  end
end
