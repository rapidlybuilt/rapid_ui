module RapidUI
  class Factory
    def initialize(&block)
      @component_class_procs = {}

      yield self if block_given?
    end

    def build(klass, *args, **kwargs, &block)
      proc = registered_proc_for(klass)

      if proc
        proc.call(klass, *args, **kwargs, factory: self, &block)
      else
        klass.new(*args, **kwargs, factory: self, &block)
      end
    end

    def register!(klass, proc)
      @component_class_procs[klass] = proc
    end

    def registered_proc_for(klass)
      @component_class_procs[klass] # TODO: subclasses?
    end

    def inspect
      "#<#{self.class.name}>"
    end
  end
end
