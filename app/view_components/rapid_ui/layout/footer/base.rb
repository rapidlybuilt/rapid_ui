module RapidUI
  module Layout
    module Footer
      class Base < ApplicationComponent
        attr_accessor :left
        attr_accessor :right

        def initialize(**kwargs, &block)
          @left = Components.new
          @right = Components.new

          super(tag_name: :footer, **kwargs, &block)
        end
      end
    end
  end
end
