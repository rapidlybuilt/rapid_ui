module RapidUI
  class ApplicationComponent < ViewComponent::Base
    # TODO: organize more (break into modules?)

    attr_accessor :tag_name
    attr_accessor :id
    attr_accessor :data
    attr_accessor :css_class

    # overridable by subclasses
    alias_method :dynamic_css_class, :css_class
    alias_method :dynamic_tag_name, :tag_name
    alias_method :dynamic_data, :data

    with_options to: :view_context do
      # Rails helpers
      delegate :asset_path
      delegate :image_path
      delegate :image_tag
    end

    def initialize(tag_name: :div, id: nil, additional_class: nil, data: {}, **kwargs)
      super()
      assert_only_class_kwarg(kwargs)

      @tag_name = tag_name
      @id = id
      @data = data
      @css_class = combine_classes(kwargs[:class], additional_class)

      yield self if block_given?
    end

    def component_tag(body = nil, tag_name: dynamic_tag_name, **attributes, &block)
      attributes = tag_attributes.merge(attributes)

      if body
        tag.send(tag_name, body, **attributes, &block)
      else
        # some tags don't accept a body
        tag.send(tag_name, **attributes, &block)
      end
    end

    def tag_attributes(attributes = {})
      attributes.merge(component_attributes)
    end

    def component_attributes
      dd = dynamic_data
      css = dynamic_css_class

      attrs = {}
      attrs[:id] = id if id
      attrs[:data] = dd if dd&.any?
      attrs[:class] = css if css.present?
      attrs
    end

    private

    def safe_component(component)
      self.class.safe_component(component)
    end

    def safe_components(*components)
      self.class.safe_components(*components)
    end

    def render(component)
      return if component.nil?
      return h(component) if component.is_a?(String)
      super(component)
    end

    def assert_only_class_kwarg(kwargs)
      keys = kwargs.keys
      return if keys.length == 0 || keys == [ :class ]

      unknown = keys - [ :class ]
      raise ArgumentError, "unknown kwargs: #{unknown.inspect}"
    end

    def combine_classes(classes, *additional_classes)
      result = [ classes, *additional_classes ].compact.join(" ")
      result if result.present?
    end

    def combine_data(data, additional_data)
      # TODO: smart merge for controller, action attributes
      data = data.merge(additional_data) if additional_data
      data
    end

    def t(key, **kwargs)
      key = "#{i18n_scope}.#{key}" if key[0] == "."
      I18n.t(key, **kwargs)
    end

    def i18n_scope
      "#{self.class.name.underscore.gsub("/", ".")}"
    end

    class << self
      def safe_component(component)
        case component
        when ViewComponent::Base
          component
        when Integer, Float, Date, Time, DateTime
          Text.new(component)
        when String
          component.html_safe? ? Html.new(component) : Text.new(component)
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
        Components.new(safe)
      end
    end
  end
end
