module RapidUI
  module Layout
    module Subheader
      module Breadcrumbs
        class FirstLastDropdownList < BaseList
          renders_one :dropdown, ->(**kwargs) {
            build(Dropdown, variant: nil, **kwargs)
          }

          def call
            contents = []

            size = array.length
            contents << render_breadcrumb(array.first) if size > 0
            contents << dropdown if size > 2
            contents << render_breadcrumb(array.last) if size > 1

            component_tag(safe_join(contents, separator))
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
            dropdown.with_button("...", skip_caret: true)
          end

          def init_dropdown_menu(dropdown)
            dropdown.with_menu do |menu|
              array[1..-2].each do |breadcrumb|
                menu.with_item(breadcrumb.name, breadcrumb.path)
              end
            end
          end
        end
      end
    end
  end
end
