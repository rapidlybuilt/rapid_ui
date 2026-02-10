module RapidUI
  module Datatable
    class Controls < ApplicationComponent
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

      module Container
        extend ActiveSupport::Concern

        included do
          include Support::ExtendableClass

          def_extendable_class :controls, superclass: Controls
        end

        class_methods do
          def register_control(type, definition, **kwargs)
            controls_class! do
              register_polymorphic_type(:items, type, definition, **kwargs)
            end
          end
        end
      end
    end
  end
end
