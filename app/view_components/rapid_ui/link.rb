module RapidUI
  class Link < ApplicationComponent
    attr_accessor :title
    attr_accessor :path

    def initialize(title_or_path, path = nil, **kwargs)
      super(tag_name: :a, **kwargs)

      @title = title_or_path if path.present?
      @path = path || title_or_path

      yield self if block_given?
    end

    def call
      component_tag(content || title, href: path)
    end
  end
end
