module RapidUI
  class Button < ApplicationComponent
    attr_accessor :icon
    attr_accessor :name
    attr_accessor :path
    attr_accessor :css_class
    attr_accessor :data

    def initialize(name, path: nil, icon: nil, data: {}, **options)
      @icon = Icon.new(icon)
      @name = name
      @path = path
      @css_class = combine_classes(options[:additional_class], options[:class])
      @data = data
    end

    def call
      body = []
      body << render(icon)
      body << name if name.present?
      body = safe_join(body)

      tag_name = path ? :a : :button
      tag.send(tag_name, body, href: path, class: css_class, data:)
    end
  end
end
