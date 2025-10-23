module RapidUI
  module Layout
    module Sidebar
      module Navigation
        class Link < ApplicationComponent
          attr_accessor :name
          attr_accessor :path
          attr_accessor :active
          alias_method :active?, :active

          renders_one :badge, Badge

          def initialize(name, path, active: nil, **kwargs)
            super(tag_name: :a, **kwargs, class: merge_classes("sidebar-link sidebar-nav-link", kwargs[:class]))

            @name = name
            @path = path
            @active = active

            yield self if block_given?
          end

          def dynamic_css_class
            merge_classes(
              super,
              ("active" if active?),
            )
          end

          def call
            content = []
            content << name
            content << badge if badge?
            content = safe_join(content)

            component_tag(content, href: path)
          end
        end
      end
    end
  end
end
