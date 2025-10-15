module RapidUI
  module Layout
    module Sidebar
      module Navigation
        class Link < ApplicationComponent
          attr_accessor :name
          attr_accessor :path
          attr_accessor :badge

          attr_writer :active

          def initialize(name, path, active: nil, **kwargs)
            super(tag_name: :a, **kwargs)

            @name = name
            @path = path
            @active = active
          end

          def build_badge(name, **kwargs)
            @badge = Badge.new(name, **kwargs)
          end

          def dynamic_css_class
            combine_classes(
              "sidebar-link",
              ("active" if active?),
              super,
            )
          end

          def active?
            @active.nil? ? current_path? : @active
          end

          def call
            content = []
            content << name
            content << render(badge) if badge
            content = safe_join(content)

            component_tag(content, href: path)
          end

          private

          def current_path?
            view_context.request.path == path
          end
        end
      end
    end
  end
end
