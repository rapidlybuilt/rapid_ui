module RapidUI
  module Layout
    module Subheader
      class Breadcrumb < ApplicationComponent
        attr_accessor :name
        attr_accessor :path

        def initialize(name, path = nil, **kwargs, &block)
          @name = name
          @path = path

          super(tag_name: :a, **kwargs, &block)
        end

        def call
          return h(name) if path.blank?

          component_tag(name, href: path, class: "typography-link")
        end
      end
    end
  end
end
