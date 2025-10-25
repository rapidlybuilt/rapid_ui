module RapidUI
  class Factory
    def initialize(&block)
      @polish_proc_for = {}

      yield self if block_given?
    end

    def build(klass, *args, **kwargs)
      instance = klass.new(*args, **kwargs, factory: self)
      polish(instance)
      instance
    end

    # TODO: API for modifying args/kwargs, generating the instance, polishing the instance
    def register_polish!(klass, proc)
      @polish_proc_for[klass] = proc
    end

    def inspect
      "#<#{self.class.name}>"
    end

    private

    def polish(instance)
      proc = polish_proc_for(instance.class)
      proc.call(instance) if proc
    end

    def polish_proc_for(klass)
      @polish_proc_for[klass] # TODO: subclasses?
    end
  end
end
