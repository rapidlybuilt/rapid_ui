module RapidUI
  module Layout
    module Subheader
      module Breadcrumbs
        class FullList < BaseList
          def call
            component_tag do
              safe_join(
                array.map { |b| render_breadcrumb(b) },
                separator,
              )
            end
          end
        end
      end
    end
  end
end
