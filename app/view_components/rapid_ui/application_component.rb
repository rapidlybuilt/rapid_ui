require "view_component"

module RapidUI
  class ApplicationComponent < ViewComponent::Base
    # TODO: organize more (break into modules?)
    include RendersWithFactory
    extend RendersPolymorphic

    attr_accessor :tag_name
    attr_accessor :id
    attr_accessor :data
    attr_accessor :css_class

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

      self.factory = factory
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

    def safe_join(components)
      super(components.map { |p| p.is_a?(ViewComponent::Base) ? render(p) : p.to_s })
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
      self.class.i18n_scope
    end

    class << self
      def i18n_scope
        @i18n_scope ||= "#{name.underscore.gsub("/", ".")}"
      end
    end
  end
end
