module RapidUI
  module Datatable
    module Controls
      extend ActiveSupport::Concern

      included do
        include RapidUI::Support::ExtendableClass

        def_extendable_class :controls, superclass: Component
      end

      class_methods do
        def register_control(type, definition, **kwargs)
          controls_class! do
            register_polymorphic_type(:items, type, definition, **kwargs)
          end
        end
      end

      class Component < ApplicationComponent
        attr_accessor :table

        renders_many_polymorphic(:items,
          # allow nesting / grouping controls
          group: ->(**kwargs) { build(self.class, table:, **kwargs) },
          button: ->(*args, **kwargs) { build(Button, *args, **kwargs) },
        )

        def initialize(table:, **kwargs)
          super(
            tag_name: :div,
            **kwargs,
          )

          @table = table
        end

        def call
          component_tag { safe_join(items) }
        end
      end
    end
  end
end
