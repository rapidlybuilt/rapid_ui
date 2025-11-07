module RapidUI
  module Layout
    module Subheader
      class Breadcrumb < ApplicationComponent
        attr_accessor :name
        attr_accessor :path

        def initialize(name, path = nil, **kwargs)
          super(tag_name: :a, **kwargs)

          @name = name
          @path = path
        end

        def call
          return h(name) if path.blank?

          component_tag(name, href: path)
        end

        class Container < ApplicationComponent
          # HACK: don't manually generate this HTML separator
          SEPARATOR = %(<span class="px-3px">&raquo;</span>).html_safe.freeze

          attr_accessor :separator

          renders_many :breadcrumbs, ->(*args, **kwargs) {
            build(Breadcrumb, *args, **kwargs)
          }

          def initialize(*args, separator: SEPARATOR, **kwargs)
            super(
              *args,
              tag_name: :div,
              **kwargs,
              class: merge_classes("subheader-breadcrumbs", kwargs[:class]),
            )

            @separator = separator
          end

          def call
            component_tag { safe_join(breadcrumbs, separator) }
          end
        end
      end
    end
  end
end
