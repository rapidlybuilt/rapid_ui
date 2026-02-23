# frozen_string_literal: true

module RapidUI
  module Datatable
    module Controls
      extend ActiveSupport::Concern

      included do
        include RapidUI::Support::ExtendableClass
        include Placement

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
          # TODO: remove the "datatable-filters" class
          group: ->(**kwargs) { build(self.class, table:, **kwargs, class: RapidUI.merge_classes("datatable-control datatable-filters", kwargs[:class])) },
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

      # Declarative placement of controls. Call +controls_placement :header+ (and
      # optionally a default list) to register a slot; this defines a class attribute
      # +header_controls+ (or +#{placement}_controls+) that you can set per table.
      # Each control is skipped when the table responds to +skip_#{id}?+ and it
      # returns true; otherwise the controls component receives +build_#{id}+.
      module Placement
        extend ActiveSupport::Concern

        class_methods do
          # Registers a placement slot (e.g. +:header+, +:footer+). Defines a class
          # attribute +#{placement}_controls+ (e.g. +header_controls+) so tables can
          # set +self.header_controls = [...]+. Optionally pass a default list.
          # Callers must call +ensure_#{placement}_controls_built+ for each placement they use.
          def controls_placement(placement, control_ids = nil)
            attr_name = :"#{placement}_controls"
            unless respond_to?(attr_name, true)
              class_attribute attr_name, default: [], instance_accessor: false
            end
            self.send(:"#{attr_name}=", (control_ids || []).dup) if control_ids

            method_name = :"ensure_#{placement}_controls_built"
            build_slot_method = :"build_#{placement}"
            return if instance_methods.include?(method_name)

            define_method(method_name) do
              return if send(placement)

              ids = self.class.send(attr_name) || []
              active = active_placement_controls(ids)
              return if active.empty?

              send(build_slot_method) do |component|
                build_controls_on_component(component, active)
              end
            end
          end
        end

        private

        def build_controls_on_component(component, control_ids)
          control_ids.each do |item|
            case item
            when Symbol
              build_method = :"build_#{item}"
              unless component.respond_to?(build_method)
                raise ArgumentError, "Control #{item.inspect} has no build method: #{component.class} does not respond to #{build_method}"
              end

              component.public_send(build_method)
            when Array
              unless component.respond_to?(:build_group)
                raise ArgumentError, "Cannot nest controls: #{component.class} does not respond to build_group"
              end

              component.build_group do |group|
                build_controls_on_component(group, item)
              end
            end
          end
        end

        # Returns the placement list filtered by skip_#{id}?, preserving nested arrays.
        # Nested arrays are kept only if at least one child is not skipped.
        def active_placement_controls(ids)
          ids.filter_map do |item|
            case item
            when Symbol
              item unless skip_control?(item)
            when Array
              filtered = item.reject { |id| skip_control?(id) }
              filtered if filtered.any?
            end
          end
        end

        def skip_control?(control_id)
          skip_method = :"skip_#{control_id}?"
          unless respond_to?(skip_method)
            raise ArgumentError, "Control #{control_id.inspect} has no skip method: #{self.class} does not respond to #{skip_method}"
          end

          public_send(skip_method)
        end
      end
    end
  end
end
