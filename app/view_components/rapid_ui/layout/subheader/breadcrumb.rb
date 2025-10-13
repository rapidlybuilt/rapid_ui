module RapidUI
  module Layout
    module Subheader
      class Breadcrumb < ApplicationComponent
        attr_accessor :name
        attr_accessor :path

        def initialize(name, path = nil)
          @name = name
          @path = path
        end

        def call
          return name if path.blank?

          link_to(name, path, class: "typography-link")
        end
      end
    end
  end
end
