module RapidUI
  class Icon < ApplicationComponent
    attr_accessor :id
    attr_accessor :size
    attr_accessor :spin
    alias_method :spin?, :spin

    def initialize(id, size: 16, spin: false)
      @id = id
      @size = size
      @spin = spin
    end

    def call
      icon_tag(id, size:, spin:) if id.present?
    end
  end
end
