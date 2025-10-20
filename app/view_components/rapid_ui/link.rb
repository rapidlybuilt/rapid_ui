module RapidUI
  class Link < ApplicationComponent
    attr_accessor :title
    attr_accessor :path

    def initialize(title, path, **kwargs)
      super(tag_name: :a, **kwargs)

      @title = title
      @path = path

      yield self if block_given?
    end

    def call
      component_tag(title, href: path)
    end
  end
end
