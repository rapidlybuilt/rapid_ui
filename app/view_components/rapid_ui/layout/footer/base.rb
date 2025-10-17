module RapidUI
  module Layout
    module Footer
      class Base < ApplicationComponent
        renders_one :left, Components
        renders_one :right, Components

        def initialize(**kwargs, &block)
          with_left
          with_right

          super(tag_name: :footer, **kwargs, &block)
        end
      end
    end
  end
end
