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

          yield self if block_given?
        end

        def call
          return h(name) if path.blank?

          component_tag(name, href: path, class: "typography-link")
        end

        class Components < RapidUI::Components
          # HACK: don't manually generate this HTML separator
          SEPARATOR = %(<span class="px-3px">&raquo;</span>).html_safe.freeze

          contains :breadcrumb, Breadcrumb

          def initialize(*args, separator: SEPARATOR, **kwargs, &block)
            super(
              *args,
              tag_name: :div,
              separator:,
              **kwargs,
              class: merge_classes("subheader-breadcrumbs", kwargs[:class]),
              &block
            )
          end
        end
      end
    end
  end
end
