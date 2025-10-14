module RapidUI
  module Layout
    module Head
      class AppleTouchIcon < ApplicationComponent
        attr_accessor :path

        def initialize(path, **kwargs)
          super(**kwargs)

          @path = path
        end

        def call
          component_tag(:link, rel: "apple-touch-icon", href: image_path(path))
        end
      end
    end
  end
end
