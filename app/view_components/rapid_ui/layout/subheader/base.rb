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
          left.find(Breadcrumb::Components) || raise("No breadcrumbs found: have you called #with_breadcrumbs?")
        end

        def with_breadcrumb(*args, **kwargs, &block)
          breadcrumbs.build(*args, **kwargs, &block)
        end
      end
    end
  end
end
