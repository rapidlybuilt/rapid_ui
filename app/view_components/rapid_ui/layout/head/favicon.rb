module RapidUI
  module Layout
    module Head
      class Favicon < ApplicationComponent
        attr_accessor :path
        attr_accessor :size
        attr_accessor :type

        def initialize(path, type:, size:)
          @path = path
          @size = size
          @type = type
        end

        def call
          tag.link rel: "icon", type:, sizes: "#{size}x#{size}", href: image_path(path)
        end

        class Components < Components::Typed
          def initialize
            super(Favicon)
          end

          def new_apple_touch(path)
            AppleTouchIcon.new(path)
          end

          def build_apple_touch(path)
            self << new_apple_touch(path)
          end
        end
      end
    end
  end
end
