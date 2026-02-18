module RapidUI
  module Search
    class Result < ApplicationComponent
      attr_accessor :title
      attr_accessor :url
      attr_accessor :description

      def initialize(title: nil, url: nil, description: nil, **kwargs)
        super(
          tag_name: :a,
          **kwargs,
          class: merge_classes("search-page-result-item", kwargs[:class]),
        )

        @title = title
        @url = url
        @description = description
      end

      def call
        body = safe_join([
          tag.div(title, class: "search-result-title"),
          tag.div(description, class: "search-result-description"),
        ])

        component_tag(body, href: url)
      end

      private

      def dynamic_data
        { result_url: url, result_title: title, result_description: description }
      end
    end
  end
end
