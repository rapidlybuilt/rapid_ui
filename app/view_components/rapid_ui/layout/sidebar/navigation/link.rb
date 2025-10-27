module RapidUI
  module Layout
    module Sidebar
      module Navigation
        class Link < RapidUI::Link
          attr_accessor :active
          alias_method :active?, :active

          renders_one :badge, Badge

          def initialize(title_or_path, path = nil, active: nil, **kwargs)
            super(title_or_path, path, **kwargs, class: merge_classes("sidebar-link sidebar-nav-link", kwargs[:class]))

            @active = active
          end

          def dynamic_css_class
            merge_classes(
              super,
              ("active" if active?),
            )
          end

          def call
            component_tag(content || build_body, href: path)
          end

          private

          def build_body
            content = [ title ]
            content << badge if badge?
            safe_join(content)
          end
        end
      end
    end
  end
end
