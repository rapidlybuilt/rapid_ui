module RapidUI
  class Text < ApplicationComponent
    attr_accessor :text

    def initialize(text, **kwargs)
      super(**kwargs)
      @text = text
    end

    def call
      if tag_attributes.any?
        component_tag(:span, text)
      else
        h(text)
      end
    end
  end
end
