module RapidUI
  module Layout
    module Head
      class Favicon < ApplicationComponent
        attr_accessor :path
        attr_accessor :size
        attr_accessor :type

        def initialize(path, type:, size:, **kwargs)
          super(**kwargs)

          @path = path
          @size = size
          @type = type
        end

        def call
          component_tag(:link, rel: "icon", type:, sizes: "#{size}x#{size}", href: image_path(path))
        end

        class Components < Components
          contains Favicon, nil
          contains AppleTouchIcon, :apple_touch
        end
      end
    end
  end
end
