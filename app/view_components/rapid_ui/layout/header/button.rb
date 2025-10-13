module RapidUI
  module Layout
    module Header
      class Button < ApplicationComponent
        attr_accessor :icon
        attr_accessor :name
        attr_accessor :path
        attr_accessor :css_class

        def initialize(name, path, icon: nil, css_class: "header-btn")
          @icon = Icon.new(icon)
          @name = name
          @path = path
          @css_class = css_class
        end

        def call
          body = []
          body << render(icon)
          body << name if name.present?

          link_to(safe_join(body), path, class: css_class)
        end
      end
    end
  end
end
