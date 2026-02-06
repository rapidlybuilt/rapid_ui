module RapidUI
  module HasComponentTag
    def self.included(base)
      base.class_eval do
        attr_accessor :tag_name
        attr_accessor :id

        # TODO: merge! implementation for each of these that uses RapidUI.merge_*
        attr_accessor :data
        attr_accessor :css_class

        # overridable by subclasses
        alias_method :dynamic_id, :id
        alias_method :dynamic_css_class, :css_class
        alias_method :dynamic_tag_name, :tag_name
        alias_method :dynamic_data, :data

        with_options to: :RapidUI do
          delegate :merge_classes
          delegate :merge_data
          delegate :merge_attributes
        end
      end
    end

    def component_tag(body = nil, tag_name: dynamic_tag_name, **attributes, &block)
      attributes = merge_attributes(component_tag_attributes, attributes)

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

    def initialize_component_tag(tag_name:, id:, data:, **kwargs)
      self.tag_name = tag_name
      self.id = id
      self.data = data
      self.css_class = assert_only_class_kwarg(kwargs)
    end

    # We can't receive `class` as a keyword argument but
    # we still want to allow it to be passed in as a keyword argument.
    def assert_only_class_kwarg(kwargs)
      keys = kwargs.keys
      return kwargs[:class] if keys.length == 0 || keys == [ :class ]

      unknown = keys - [ :class ]
      raise ArgumentError, "unknown kwargs: #{unknown.inspect}"
    end
  end
end
