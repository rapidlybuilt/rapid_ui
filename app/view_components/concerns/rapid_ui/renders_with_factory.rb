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
        # TODO: handle polymorphism
        proc = RendersWithFactory.build_proc(name, class_or_proc)
        define_renders_one_build_method(name, proc)

        super(name, proc)
      end

      def renders_many(name, class_or_proc = nil)
        proc = RendersWithFactory.build_proc(name, class_or_proc)
        define_renders_many_build_method(name, proc)

        super(name, proc)
      end

      private

      def define_renders_one_build_method(name, proc)
        new_method = :"new_#{name}"
        define_method(new_method, &proc)

        define_method(:"build_#{name}") do |*args, **kwargs, &block|
          instance = send(new_method, *args, **kwargs, &block)
          set_slot(name, instance)
          instance
        end
      end

      def define_renders_many_build_method(name, proc)
        singular = name.to_s.singularize

        new_method = :"new_#{singular}"
        define_method(new_method, &proc)

        define_method(:"build_#{singular}") do |*args, **kwargs, &block|
          instance = send(new_method, *args, **kwargs, &block)
          push_slot(name, instance)
          instance
        end
      end
    end

    class << self
      def build_proc(name, class_or_proc)
        return class_or_proc if class_or_proc.is_a?(Proc)

        klass = class_or_proc if class_or_proc.is_a?(Class)

        ->(*args, **kwargs, &block) do
          klass ||= self.class.const_get(class_or_proc || name.to_s.camelize)
          build(klass, *args, **kwargs, &block)
        end
      end

      def new_proc(name, class_or_proc)
        return class_or_proc if class_or_proc.is_a?(Proc)

        klass = class_or_proc if class_or_proc.is_a?(Class)

        ->(*args, **kwargs, &block) do
          klass ||= self.class.const_get(class_or_proc || name.to_s.camelize)
          klass.new(*args, **kwargs, &block)
        end
      end
    end
  end
end
