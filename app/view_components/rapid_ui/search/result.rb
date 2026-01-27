module RapidUI
  module Search
    class Result < ApplicationComponent
      attr_accessor :title
      attr_accessor :url
      attr_accessor :description

      def initialize(title:, url:, description: nil, **kwargs)
        super(tag_name: :a, **kwargs)

        @title = title
        @url = url
        @description = description
      end

      def call
        component_tag(href: url) do
          safe_join([
            tag.div(title, class: "search-result-title"),
            description.present? ? tag.div(description, class: "search-result-description") : nil,
          ].compact)
        end
      end

      def dynamic_css_class
        merge_classes("search-result-item", css_class)
      end
    end
  end
end
