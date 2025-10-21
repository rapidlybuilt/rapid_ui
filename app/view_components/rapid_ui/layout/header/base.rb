module RapidUI
  module Layout
    module Header
      class Base < ApplicationComponent
        renders_one :left, Components
        renders_one :right, Components

        def initialize(**kwargs)
          super(tag_name: :header, **kwargs)

          with_left
          with_right

          yield self if block_given?
        end
      end
    end
  end
end
