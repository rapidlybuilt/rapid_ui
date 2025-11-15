module RapidUI
  module Layout
    module Subheader
      module Breadcrumbs
        class ResponsiveList < BaseList
          # determines which list is initially shown before JavaScript looks at the screen size
          attr_accessor :mode

          renders_one :dropdown_list, ->(**kwargs) {
            build_child(DropdownList, "dropdown-list", "dropdownList", **kwargs)
          }

          renders_one :first_last_dropdown_list, ->(**kwargs) {
            build_child(FirstLastDropdownList, "first-last-dropdown-list", "firstLastDropdownList", **kwargs)
          }

          renders_one :full_list, ->(**kwargs) {
            build_child(FullList, "full-list", "fullList", **kwargs)
          }

          def initialize(*args, mode: nil, **kwargs)
            super(*args, **kwargs)
            @mode = mode
          end

          def call
            component_tag do
              safe_join([
                dropdown_list,
                first_last_dropdown_list,
                full_list,
              ])
            end
          end

          private

          def before_render
            super

            unless array.empty?
              with_dropdown_list unless dropdown_list?
              with_first_last_dropdown_list unless first_last_dropdown_list?
              with_full_list unless full_list?
            end
          end

          def mode_container_class(mode)
            css = "subheader-breadcrumbs-#{mode}"
            return css if mode == self.mode

            merge_classes(css, "hidden")
          end

          def build_child(klass, css, target, **kwargs)
            build(
              klass,
              array,
              separator:,
              **kwargs,
              skip_controller: true,
              class: merge_classes(mode_container_class(css), kwargs[:class]),
              data: merge_data({ breadcrumbs_target: target }, kwargs[:data]),
            )
          end
        end
      end
    end
  end
end
