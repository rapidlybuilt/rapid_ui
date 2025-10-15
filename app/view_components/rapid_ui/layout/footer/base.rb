module RapidUI
  module Layout
    module Footer
      class Base < ApplicationComponent
        attr_accessor :left
        attr_accessor :right

        def initialize(**kwargs)
          super(tag_name: :footer, **kwargs)

          @left = Components.new
          @right = Components.new
        end
      end
    end
  end
end
