module RapidUI
  module Layout
    module Header
      class Text < ApplicationComponent
        attr_accessor :text
        attr_accessor :css_class

        def initialize(text, additional_class: "header-text", **kwargs)
          @text = text
          @css_class = combine_classes(additional_class, kwargs[:class])
        end

        def call
          tag.span(text, class: css_class)
        end
      end
    end
  end
end
