module RapidUI
  class Text < ApplicationComponent
    attr_accessor :text

    def initialize(text, **kwargs)
      super(tag_name: nil, **kwargs)
      @text = text
    end

    def dynamic_tag_name
      @tag_name || (tag_attributes.any? ? :span : nil)
    end

    def call
      dynamic_tag_name ? component_tag(text) : h(text)
    end
  end
end
