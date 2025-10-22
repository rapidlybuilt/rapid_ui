module RapidUI
  class Tag < ApplicationComponent
    attr_accessor :attributes

    def initialize(*args, tag_name: nil, id: nil, data: {}, factory:, **attributes)
      super(tag_name:, id:, data:, factory:, class: attributes[:class])

      with_content(safe_components(*args)) if args.any?
      @attributes = attributes.except(:class)

      yield self if block_given?
    end

    def component_tag_attributes
      super.merge(attributes)
    end

    def call
      # if it doesn't have a tag name, then it's not just a Text Node
      dynamic_tag_name ? component_tag(render(content)) : h(render(content))
    end
  end
end
