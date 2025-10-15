module RapidUI
  module Layout
    module Subheader
      class Breadcrumb < ApplicationComponent
        attr_accessor :name
        attr_accessor :path

        def initialize(name, path = nil, **kwargs)
          super(tag_name: :a, **kwargs)

          @name = name
          @path = path
        end

        def call
          return h(name) if path.blank?

          component_tag(name, href: path, class: "typography-link")
        end
      end
    end
  end
end
