module RapidUI
  module Layout
    module Subheader
      class Breadcrumb < ApplicationComponent
        attr_accessor :name
        attr_accessor :path

        def initialize(name, path = nil, **kwargs, &block)
          @name = name
          @path = path

          super(tag_name: :a, **kwargs, &block)
        end

        def call
          return h(name) if path.blank?

          component_tag(name, href: path, class: "typography-link")
        end

        class Components < RapidUI::Components
          # HACK: don't manually generate this HTML separator
          SEPARATOR = %(<span class="px-3px">&raquo;</span>).html_safe.freeze

          contains Breadcrumb, nil

          def initialize(*args, separator: SEPARATOR, **kwargs, &block)
            super(
              *args,
              tag_name: :div,
              additional_class: "subheader-breadcrumbs",
              **kwargs,
              &block
            )
          end
        end
      end
    end
  end
end
