module RapidUI
  module Layout
    module Header
      class Base < ApplicationComponent
        renders_one :left, Components
        renders_one :right, Components

        def initialize(**kwargs, &block)
          with_left
          with_right

          super(tag_name: :header, **kwargs, &block)
        end
      end
    end
  end
end
