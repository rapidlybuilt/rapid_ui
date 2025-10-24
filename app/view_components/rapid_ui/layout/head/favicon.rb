module RapidUI
  module Layout
    module Head
      class Favicon < ApplicationComponent
        attr_accessor :path
        attr_accessor :size
        attr_accessor :type
        attr_accessor :rel

        def initialize(path, type:, size:, rel: "icon", **kwargs)
          super(tag_name: :link, **kwargs)

          @path = path
          @size = size
          @type = type
          @rel = rel

          yield self if block_given?
        end

        def call
          component_tag(rel:, type:, sizes: "#{size}x#{size}", href: image_path(path))
        end
      end
    end
  end
end
