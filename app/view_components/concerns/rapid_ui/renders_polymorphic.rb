module RapidUI
  module RendersPolymorphic
    def renders_many_polymorphic(name, skip_tags: false, include_suffix: false, **types)
      types[:tag] ||= Tag unless skip_tags

      uses_factory = included_modules.include?(RendersWithFactory)
      singular = name.to_s.singularize

      # defined by renders_many
      typed_name = :"typed_#{name}" # prepend `typed` so we can have a child type named `with_#{child}`
      with_method = :"with_typed_#{singular}"
      build_method = :"build_typed_#{singular}"

      type_methods = types.each_with_object({}) do |(type, definition), methods|
        # proc used to instantiate the new component
        proc = RendersWithFactory.send(uses_factory ? :build_proc : :new_proc, singular, definition)

        # this is used to instantiate the new component
        methods[type] = define_renders_many_polymorphic_new_method(proc, singular, type, include_suffix:)
      end

      # actually call the ViewComponent::Base method
      renders_many(typed_name, ->(type, *args, **kwargs, &block) {
        method = type_methods[type]
        binding.irb unless method
        raise ArgumentError, "invalid item type: #{type} (#{type_methods.keys.inspect})" unless method
        send(method, *args, **kwargs, &block)
      })

      # alias the non-typed versions of the methods, though type.keys below it may override some
      alias_method name, typed_name
      alias_method :"with_#{singular}", with_method
      alias_method :"build_#{singular}", build_method if uses_factory

      types.keys.each do |type|
        # this is syntactic sugar for `with_*`
        define_renders_many_polymorphic_with_method(with_method, singular, type, include_suffix:)

        # this is syntactic sugar for `build_*`
        define_renders_many_polymorphic_build_method(build_method, singular, type, include_suffix:) if uses_factory
      end
    end

    private

    def define_renders_many_polymorphic_new_method(proc, singular, type, include_suffix:)
      new_method = include_suffix ? :"new_#{type}_#{singular}" : :"new_#{type}"
      define_method(new_method, &proc)
      new_method
    end

    def define_renders_many_polymorphic_with_method(with_method, name, type, include_suffix:)
      with_type_method = include_suffix ? :"with_#{type}_#{name}" : :"with_#{type}"

      define_method(with_type_method) do |*args, **kwargs, &block|
        send(with_method, type, *args, **kwargs, &block)
      end

      with_type_method
    end

    def define_renders_many_polymorphic_build_method(build_method, name, type, include_suffix:)
      build_type_method = include_suffix ? :"build_#{type}_#{name}" : :"build_#{type}"

      define_method(build_type_method) do |*args, **kwargs, &block|
        send(build_method, type, *args, **kwargs, &block)
      end

      build_type_method
    end
  end
end
