module RapidUI
  class Text < ApplicationComponent
    attr_accessor :text

    def initialize(text, **kwargs, &block)
      @text = text

      super(tag_name: nil, **kwargs, &block)
    end

    def dynamic_tag_name
      @tag_name || (component_tag_attributes.any? ? :span : nil)
    end

    def call
      dynamic_tag_name ? component_tag(text) : h(text)
    end
  end
end
