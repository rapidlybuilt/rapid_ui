module RapidUI
  class Link < ApplicationComponent
    attr_accessor :title
    attr_accessor :path

    def initialize(title, path, **kwargs, &block)
      @title = title
      @path = path

      super(tag_name: :a, **kwargs, &block)
    end

    def call
      component_tag(title, href: path)
    end
  end
end
