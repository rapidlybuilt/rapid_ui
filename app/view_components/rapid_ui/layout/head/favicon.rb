module RapidUI
  module Layout
    module Head
      class Favicon < ApplicationComponent
        attr_accessor :path
        attr_accessor :size
        attr_accessor :type

        def initialize(path, type:, size:, **kwargs, &block)
          @path = path
          @size = size
          @type = type

          super(tag_name: :link, **kwargs, &block)
        end

        def call
          component_tag(rel: "icon", type:, sizes: "#{size}x#{size}", href: image_path(path))
        end

        class Components < Components
          contains Favicon, nil
          contains AppleTouchIcon, :apple_touch
        end
      end
    end
  end
end
