module RapidUI
  class Icon < ApplicationComponent
    attr_accessor :id
    attr_accessor :size
    attr_accessor :spin
    alias_method :spin?, :spin
    attr_accessor :css_class

    def initialize(id, size: 16, spin: false, **kwargs)
      @id = id
      @size = size
      @spin = spin
      @css_class = combine_classes(kwargs[:additional_class], kwargs[:class])
    end

    def call
      icon_tag(id, size:, spin:, class: css_class) if id.present?
    end
  end
end
