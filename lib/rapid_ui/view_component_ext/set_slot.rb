module RapidUI
  module ViewComponentExt
    # Extends ViewComponent::Base to allow setting slots directly with component instances
    #
    # By default, ViewComponent requires using factory methods defined by renders_one/renders_many
    # to create and set slot content. This extension adds the ability to set slots directly with
    # existing component instances.
    #
    # @example Setting a slot directly
    #   class MyComponent < ViewComponent::Base
    #     renders_one :header
    #   end
    #
    #   component = MyComponent.new
    #   header = HeaderComponent.new(title: "Hello")
    #   component.header = header # Uses the setter added by this extension
    module SetSlot
      # Instance methods to add to ViewComponent::Base
      module BaseExt
        private

        def set_slot(name, component)
          @__vc_set_slots ||= {}
          slot = ViewComponent::Slot.new(self)
          slot.__vc_component_instance = component
          @__vc_set_slots[name] = slot
        end

        module ClassMethods
          def renders_one(slot_name, callable = nil)
            super

            define_method :"#{slot_name}=" do |component|
              set_slot(slot_name, component)
            end
          end

          # TODO: how should this work?
          # def renders_many(slot_name, callable = nil)
          #   super # Call the original renders_many

          #   singular_name = ActiveSupport::Inflector.singularize(slot_name)

          #   # Define the setter method (e.g., item=)
          #   define_method :"#{singular_name}=" do |component|
          #     set_slot(slot_name, component)
          #   end
          # end
        end
      end
    end
  end
end

ViewComponent::Base.prepend(RapidUI::ViewComponentExt::SetSlot::BaseExt)
ViewComponent::Base.singleton_class.prepend(RapidUI::ViewComponentExt::SetSlot::BaseExt::ClassMethods)
