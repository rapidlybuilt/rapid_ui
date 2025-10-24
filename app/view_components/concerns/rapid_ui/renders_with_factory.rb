module RapidUI
  module RendersWithFactory
    def self.included(base)
      base.extend(ClassMethods)

      base.with_options to: :factory do
        delegate :build
      end
    end

    attr_accessor :factory

    private

    def set_slot(name, component)
      @__vc_set_slots ||= {}
      slot = ViewComponent::Slot.new(self)
      slot.__vc_component_instance = component
      @__vc_set_slots[name] = slot
    end

    def push_slot(name, component)
      @__vc_set_slots ||= {}
      slot = ViewComponent::Slot.new(self)
      slot.__vc_component_instance = component
      @__vc_set_slots[name] ||= []
      @__vc_set_slots[name] << slot
    end

    module ClassMethods
      def renders_one(name, class_or_proc = nil)
        proc = renders_via_factory_proc(name, class_or_proc)
        define_renders_one_build_method(name, proc)

        super(name, proc)
      end

      def renders_many(name, class_or_proc = nil)
        proc = renders_via_factory_proc(name, class_or_proc)
        define_renders_many_build_method(name, proc)

        super(name, proc)
      end

      private

      # TODO: handle polymorphism
      def renders_via_factory_proc(name, class_or_proc)
        return class_or_proc if class_or_proc.is_a?(Proc)

        klass = class_or_proc if class_or_proc.is_a?(Class)

        ->(*args, **kwargs, &block) do
          klass ||= self.class.const_get(class_or_proc || name.to_s.camelize)
          build(klass, *args, **kwargs, &block)
        end
      end

      def define_renders_one_build_method(name, proc)
        define_method(:"build_#{name}") do |*args, **kwargs, &block|
          instance = instance_exec(*args, **kwargs, &proc)

          # FIXME: this block should be passed into #initialize
          block.call(instance) if block

          set_slot(name, instance)
          instance
        end
      end

      def define_renders_many_build_method(name, proc)
        define_method(:"build_#{name.to_s.singularize}") do |*args, **kwargs, &block|
          instance = instance_exec(*args, **kwargs, &proc)

          # FIXME: this block should be passed into #initialize
          block.call(instance) if block

          push_slot(name, instance)
          instance
        end
      end
    end
  end
end
