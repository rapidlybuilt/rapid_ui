module RapidUI
  module Layout
    module Subheader
      class Base < ApplicationComponent
        renders_one :left, Components
        renders_one :right, Components

        with_options to: :breadcrumbs do
          delegate :with_breadcrumb
        end

        def initialize(**kwargs)
          super(**kwargs)

          with_left
          with_right

          yield self if block_given?
        end

        def breadcrumbs
          # HACK: left should expose a single breadcrumb instance
          left.find(Breadcrumb::Components) || raise("No breadcrumbs found: have you called #with_breadcrumbs?")
        end
      end
    end
  end
end
