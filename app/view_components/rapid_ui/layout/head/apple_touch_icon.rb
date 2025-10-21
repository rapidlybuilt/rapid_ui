module RapidUI
  module Layout
    module Head
      class AppleTouchIcon < ApplicationComponent
        attr_accessor :path

        def initialize(path, **kwargs)
          super(tag_name: :link, **kwargs)

          @path = path

          yield self if block_given?
        end

        def call
          component_tag(rel: "apple-touch-icon", href: image_path(path))
        end
      end
    end
  end
end
