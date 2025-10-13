module RapidUI
  module Layout
    module Sidebar
      module Navigation
        class Link < ApplicationComponent
          attr_accessor :name
          attr_accessor :path
          attr_accessor :badge

          attr_writer :active
          attr_writer :css_class

          def initialize(name, path, active: nil, **kwargs)
            @name = name
            @path = path
            @active = active
            @css_class = combine_classes("sidebar-link", kwargs[:class])
          end

          def build_badge(name, variant: "primary", **kwargs)
            @badge = Badge.new(name, variant:, **kwargs)
          end

          def css_class
            css = @css_class || ""
            css += " active" if active?
            css
          end

          def active?
            @active.nil? ? current_path? : @active
          end

          def call
            content = []
            content << name
            content << render(badge) if badge
            content = safe_join(content)

            link_to(content, path, class: css_class)
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
