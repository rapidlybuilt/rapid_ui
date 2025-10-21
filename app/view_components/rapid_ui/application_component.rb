module RapidUI
  class ApplicationComponent < ViewComponent::Base
    # TODO: organize more (break into modules?)

    attr_accessor :tag_name
    attr_accessor :id
    attr_accessor :data
    attr_accessor :css_class
    attr_accessor :factory

    # overridable by subclasses
    alias_method :dynamic_id, :id
    alias_method :dynamic_css_class, :css_class
    alias_method :dynamic_tag_name, :tag_name
    alias_method :dynamic_data, :data

    with_options to: :view_context do
      # Rails helpers
      delegate :asset_path
      delegate :image_path
      delegate :image_tag
    end

    def initialize(tag_name: :div, id: nil, data: {}, factory:, **kwargs)
      super()
      assert_only_class_kwarg(kwargs)

      @tag_name = tag_name
      @id = id
      @data = data
      @css_class = kwargs[:class]
      @factory = factory
      raise ArgumentError, "factory is required" unless factory
    end

    def component_tag(body = nil, tag_name: dynamic_tag_name, **attributes, &block)
      attributes = merge_attributes(component_tag_attributes, **attributes)

      if body
        tag.send(tag_name, body, **attributes, &block)
      else
        # some tags don't accept a body
        tag.send(tag_name, **attributes, &block)
      end
    end

    def component_tag_attributes
      # allow subclasses to override the ID with dynamic Ruby logic
      did = dynamic_id
      dd = dynamic_data
      dcss = dynamic_css_class

      attrs = {}
      attrs[:id] = did if did
      attrs[:data] = dd if dd&.any?
      attrs[:class] = dcss if dcss.present?
      attrs
    end

    private

    with_options to: :RapidUI do
      delegate :merge_classes
      delegate :merge_data
      delegate :merge_attributes
    end

    def build(klass, *args, **kwargs, &block)
      if factory
        factory.build(klass, *args, **kwargs, &block)
      else
        klass.new(*args, **kwargs, &block)
      end
    end

    def safe_component(component)
      case component
      when ViewComponent::Base
        component
      when Integer, Float, Date, Time, DateTime, String
        build(Tag).with_content(component)
      when NilClass
        nil
      else
        raise ArgumentError, "invalid component: #{component.class.name}"
      end
    end

    def safe_components(*components)
      safe = components.each_with_object([]) do |component, safe|
        if component.is_a?(Components)
          safe.concat(component.array)
        else
          c = safe_component(component)
          safe << c if c
        end
      end

      # optimization when it's not actually multiple components
      return safe.first if safe.length < 2

      build(Components, safe)
    end

    def render(component)
      return if component.nil?
      return h(component) if component.is_a?(String)
      super(component)
    end

    # We can't receive `class` as a keyword argument but
    # we still want to allow it to be passed in as a keyword argument.
    def assert_only_class_kwarg(kwargs)
      keys = kwargs.keys
      return if keys.length == 0 || keys == [ :class ]

      unknown = keys - [ :class ]
      raise ArgumentError, "unknown kwargs: #{unknown.inspect}"
    end

    def t(key, **kwargs)
      key = "#{i18n_scope}.#{key}" if key[0] == "."
      I18n.t(key, **kwargs)
    end

    def i18n_scope
      "#{self.class.name.underscore.gsub("/", ".")}"
    end

    class << self
      def renders_one(name, class_or_proc = nil)
        if class_or_proc.is_a?(Proc)
          proc = class_or_proc
        else
          klass = class_or_proc if class_or_proc.is_a?(Class)

          proc = ->(*args, **kwargs, &block) do
            klass ||= self.class.const_get(class_or_proc || name.to_s.camelize)
            build(klass, *args, **kwargs, &block)
          end
        end

        define_component_build_methods(name, proc)
        super(name, proc)
      end

      def define_component_build_methods(name, proc)
        set_method = :"#{name}="
        new_method = :"new_#{name}"
        build_method = :"build_#{name}"

        define_method(new_method, &proc)

        define_method(build_method) do |*args, **kwargs, &block|
          instance = send(new_method, *args, **kwargs, &block)
          send(set_method, instance)
          instance
        end
      end
    end
  end
end
