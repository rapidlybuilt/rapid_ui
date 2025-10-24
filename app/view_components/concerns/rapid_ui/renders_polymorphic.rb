module RapidUI
  module RendersPolymorphic
    def renders_many_polymorphic(name, skip_tags: false, skip_suffix: false, **types)
      types = preprocess_renders_polymorphic_types(name.to_s.singularize, types, skip_tags:, skip_suffix:)

      renders_many(name, ->(type, *args, **kwargs, &block) {
        definition = types[type]
        raise ArgumentError, "invalid item type: #{type} (#{types.keys.inspect})" unless definition

        case definition
        when Class
          definition.new(*args, **kwargs, &block)
        when Proc
          instance = instance_exec(*args, **kwargs, &definition)
          # FIXME: this block should be passed into #initialize
          block.call(instance) if block
          instance
        else
          raise ArgumentError, "invalid item type: #{type} (#{types.keys.inspect})"
        end
      })
    end

    private

    def preprocess_renders_polymorphic_types(name, types, skip_tags:, skip_suffix:)
      types[:tag] ||= Tag unless skip_tags

      types.each do |type, definition|
        types[type] = preprocess_renders_polymorphic_type(name, type, definition, skip_suffix:)
      end
    end

    def preprocess_renders_polymorphic_type(name, type, definition, skip_suffix:)
      define_renders_polymorphic_with_method(name, type, definition, skip_suffix:)

      # HACK: these two need to coordinate when they're together
      return definition unless included_modules.include?(RendersWithFactory)

      define_renders_polymorphic_build_method(name, type, definition, skip_suffix:)

      case definition
      when Class, String
        renders_via_factory_proc(name, definition)
      when Proc
        definition
      else
        raise ArgumentError, "invalid item type: #{type} (#{types.keys.inspect})"
      end
    end

    def define_renders_polymorphic_with_method(name, type, definition, skip_suffix:)
      with_method = :"with_#{name}"
      with_type_method = skip_suffix ? :"with_#{type}" : :"with_#{type}_#{name}"

      define_method(with_type_method) do |*args, **kwargs, &block|
        send(with_method, type, *args, **kwargs, &block)
      end
    end

    def define_renders_polymorphic_build_method(name, type, definition, skip_suffix:)
      build_method = :"build_#{name}"
      build_type_method = skip_suffix ? :"build_#{type}" : :"build_#{type}_#{name}"

      define_method(build_type_method) do |*args, **kwargs, &block|
        send(build_method, type, *args, **kwargs, &block)
      end
    end
  end
end
