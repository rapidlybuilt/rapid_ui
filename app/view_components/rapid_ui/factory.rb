module RapidUI
  class Factory
    def initialize(&block)
      @polish_proc_for = {}

      yield self if block_given?
    end

    def new(klass, *args, **kwargs)
      klass.new(*args, **kwargs, factory: self)
    end

    def build(*args, **kwargs, &block)
      instance = new(*args, **kwargs)
      block.call(instance) if block
      polish(instance)
      instance
    end

    def polish(instance)
      proc = polish_proc_for(instance.class)
      proc.call(instance) if proc
    end

    # TODO: API for modifying args/kwargs, generating the instance, polishing the instance
    def register_polish!(klass, proc)
      @polish_proc_for[klass] = proc
    end

    def inspect
      "#<#{self.class.name}>"
    end

    private

    def polish_proc_for(klass)
      @polish_proc_for[klass] # TODO: subclasses?
    end
  end
end
