module RapidUI
  module Layout
    module Head
      class Favicon < ApplicationComponent
        attr_accessor :path
        attr_accessor :size
        attr_accessor :type

        def initialize(path, type:, size:, **kwargs)
          super(tag_name: :link, **kwargs)

          @path = path
          @size = size
          @type = type

          yield self if block_given?
        end

        def call
          component_tag(rel: "icon", type:, sizes: "#{size}x#{size}", href: image_path(path))
        end

        class Components < Components
          contains :favicon, Favicon
          contains :apple_touch_icon, AppleTouchIcon
        end
      end
    end
  end
end
