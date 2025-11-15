module RapidUI
  module Layout
    module Subheader
      module Breadcrumbs
        class BaseList < ApplicationComponent
          # HACK: don't manually generate this HTML separator
          SEPARATOR = %(<span class="px-3px">&raquo;</span>).html_safe.freeze

          attr_accessor :array
          attr_accessor :separator

          def initialize(array = Array.new, separator: SEPARATOR, skip_controller: false, **kwargs)
            super(
              tag_name: :div,
              **kwargs,
              class: merge_classes("subheader-breadcrumbs", kwargs[:class]),
              data: merge_data(kwargs[:data], skip_controller ? {} : { controller: "breadcrumbs" }),
            )

            @array = array
            @separator = separator
          end

          def build_breadcrumb(name, path = nil)
            array.build(name, path)
          end
          alias_method :with_breadcrumb, :build_breadcrumb

          def render_breadcrumb(breadcrumb)
            name = breadcrumb.name
            path = breadcrumb.path

            path.blank? ? tag.span(name) : tag.a(name, href: path)
          end
        end
      end
    end
  end
end
