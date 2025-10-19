module RapidUI
  # TODO: is this class necessary? It's basically just a ViewComponent wrapper of raw HTML.
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
