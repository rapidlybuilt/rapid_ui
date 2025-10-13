module RapidUI
  module Layout
    module Head
      class AppleTouchIcon < ApplicationComponent
        attr_accessor :path

        def initialize(path)
          @path = path
        end

        def call
          tag.link rel: "apple-touch-icon", href: image_path(path)
        end
      end
    end
  end
end
