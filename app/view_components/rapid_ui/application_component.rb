require "view_component"

module RapidUI
  class ApplicationComponent < ViewComponent::Base
    attr_accessor :id
    attr_accessor :data
    attr_accessor :css_class

    # overridable by subclasses
    alias_method :dynamic_css_class, :css_class

    with_options to: :view_context do
      # Rails helpers
      delegate :asset_path
      delegate :image_path
      delegate :image_tag
    end

    def initialize(id: nil, additional_class: nil, data: {}, **kwargs)
      assert_only_class_kwarg(kwargs)

      @id = id
      @data = data
      @css_class = combine_classes(kwargs[:class], additional_class)
    end

    def component_tag(name, body = nil, **attributes, &block)
      attributes = tag_attributes.merge(attributes)

      if body
        tag.send(name, body, **attributes, &block)
      else
        # some tags don't accept a body
        tag.send(name, **attributes, &block)
      end
    end

    def tag_attributes(attributes = {})
      attributes.merge(component_attributes)
    end

    def component_attributes
      attrs = {}
      attrs[:id] = id if id
      attrs[:data] = data if data&.any?
      attrs[:class] = dynamic_css_class if dynamic_css_class.present?
      attrs
    end

    private

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
  end
end
