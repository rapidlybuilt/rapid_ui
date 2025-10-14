module RapidUI
  # TODO: HTML
  class Html < ApplicationComponent
    attr_accessor :html

    def initialize(html)
      @html = html
    end

    def call
      html
    end
  end
end
