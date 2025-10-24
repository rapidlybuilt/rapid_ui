module RapidUI
  module RendersPolymorphic
    def renders_many_polymorphic(name, skip_tags: false, include_suffix: false, **types)
      types = preprocess_renders_polymorphic_types(name.to_s.singularize, types, skip_tags:, include_suffix:)

      typed_name = :"typed_#{name}"
      renders_many(typed_name, ->(type, *args, **kwargs) {
        definition = types[type]
        raise ArgumentError, "invalid item type: #{type} (#{types.keys.inspect})" unless definition

        case definition
        when Class
          definition.new(*args, **kwargs)
        when Proc
          instance_exec(*args, **kwargs, &definition)
        else
          raise ArgumentError, "invalid item type: #{type} (#{types.keys.inspect})"
        end
      })
      alias_method name, typed_name
    end

    private

    def preprocess_renders_polymorphic_types(name, types, skip_tags:, include_suffix:)
      types[:tag] ||= Tag unless skip_tags

      types.each do |type, definition|
        types[type] = preprocess_renders_polymorphic_type(name, type, definition, include_suffix:)
      end
    end

    def preprocess_renders_polymorphic_type(name, type, definition, include_suffix:)
      define_renders_polymorphic_with_method(name, type, definition, include_suffix:)

      # HACK: these two need to coordinate when they're together
      return definition unless included_modules.include?(RendersWithFactory)

      define_renders_polymorphic_build_method(name, type, definition, include_suffix:)

      case definition
      when Class, String
        renders_via_factory_proc(name, definition)
      when Proc
        definition
      else
        raise ArgumentError, "invalid item type: #{type}"
      end
    end

    def define_renders_polymorphic_with_method(name, type, definition, include_suffix:)
      with_method = :"with_typed_#{name}"
      with_type_method = include_suffix ? :"with_#{type}_#{name}" : :"with_#{type}"

      define_method(with_type_method) do |*args, **kwargs, &block|
        send(with_method, type, *args, **kwargs, &block)
      end
    end

    def define_renders_polymorphic_build_method(name, type, definition, include_suffix:)
      build_method = :"build_typed_#{name}"
      build_type_method = include_suffix ? :"build_#{type}_#{name}" : :"build_#{type}"

      define_method(build_type_method) do |*args, **kwargs, &block|
        send(build_method, type, *args, **kwargs, &block)
      end
    end
  end
end
