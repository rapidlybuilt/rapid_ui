module RapidUI
  module RendersWithFactory
    def renders_one(name, class_or_proc = nil)
      proc = renders_via_factory_proc(name, class_or_proc)
      super(name, proc)
    end

    def renders_many(name, class_or_proc = nil)
      proc = renders_via_factory_proc(name, class_or_proc)
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
  end
end
