module RapidUI
  module Layout
    module Subheader
      class Button < ApplicationComponent
        attr_accessor :icon
        attr_accessor :name
        attr_accessor :path

        def initialize(icon, path, title: nil)
          @icon = Icon.new(icon)
          @path = path
          @title = title
        end

        def call
          link_to(render(icon), path, class: "subheader-btn", title:)
        end
      end
    end
  end
end
