module RapidUI
  class Badge < ApplicationComponent
    attr_accessor :text
    attr_accessor :variant
    attr_accessor :css_class

    def initialize(text, variant: "primary", **kwargs)
      @text = text
      @variant = variant
      @css_class = combine_classes("badge", "badge-#{variant}", kwargs[:additional_class], kwargs[:class])
    end

    def call
      tag.span(text, class: css_class)
    end
  end
end
