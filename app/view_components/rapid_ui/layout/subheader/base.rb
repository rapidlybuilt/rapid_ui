module RapidUI
  module Layout
    module Subheader
      class Base < ApplicationComponent
        renders_one :left, Components
        renders_one :right, Components

        def initialize(**kwargs, &block)
          with_left
          with_right

          super(**kwargs, &block)
        end

        def breadcrumbs
          # HACK: left should expose a single breadcrumb instance
          left.find(Breadcrumb::Components)
        end
      end
    end
  end
end
