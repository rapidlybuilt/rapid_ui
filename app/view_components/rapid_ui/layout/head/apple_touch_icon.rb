module RapidUI
  module Layout
    module Head
      class AppleTouchIcon < ApplicationComponent
        attr_accessor :path

        def initialize(path, **kwargs, &block)
          @path = path

          super(tag_name: :link, **kwargs, &block)
        end

        def call
          component_tag(rel: "apple-touch-icon", href: image_path(path))
        end
      end
    end
  end
end
