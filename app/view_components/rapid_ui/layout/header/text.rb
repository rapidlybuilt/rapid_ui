module RapidUI
  module Layout
    module Header
      class Text < ApplicationComponent
        attr_accessor :text
        attr_accessor :css_class

        def initialize(text, css_class: "header-text")
          @text = text
          @css_class = css_class
        end

        def call
          tag.span(text, class: css_class)
        end
      end
    end
  end
end
