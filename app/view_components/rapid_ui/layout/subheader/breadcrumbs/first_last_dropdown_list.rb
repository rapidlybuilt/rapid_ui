module RapidUI
  module Layout
    module Subheader
      module Breadcrumbs
        class FirstLastDropdownList < BaseList
          renders_one :dropdown, ->(**kwargs) {
            build(Dropdown, variant: nil, **kwargs)
          }

          def call
            component_tag(safe_join([
              render_breadcrumb(array.first),
              dropdown,
              render_breadcrumb(array.last),
            ], separator))
          end

          private

          def before_render
            super
            init_dropdown unless dropdown?
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
