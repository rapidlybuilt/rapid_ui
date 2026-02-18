module RapidUI
  module Search
    class Page < ApplicationComponent
      attr_accessor :static_path
      attr_accessor :dynamic_path
      attr_accessor :search_path

      attr_accessor :title
      attr_accessor :placeholder
      attr_accessor :submit_text
      attr_accessor :empty_results_text
      attr_accessor :loading_text

      attr_accessor :query

      self.stimulus_controller = "search-page"

      renders_many :results, ->(**kwargs) do
        build(RapidUI::Search::Result, **kwargs)
      end

      renders_one :loading, ->(**kwargs) do
        build(RapidUI::Icon, "loader", spin: true, **kwargs)
      end

      def initialize(static_path: nil, dynamic_path: nil, search_path: nil, **kwargs)
        super(
          **kwargs,
          class: merge_classes("search-page", kwargs[:class]),
        )

        @static_path = static_path
        @dynamic_path = dynamic_path
        @search_path = search_path

        @title = t(".title")
        @placeholder = t(".placeholder")
        @submit_text = t(".submit_text")
        @empty_results_text = t(".empty_results_text")
        @loading_text = t(".loading_text")
      end

      def form_url
        @search_path || url_for
      end

      def dynamic_data
        super.merge(
          search_page_static_path_value: @static_path,
          search_page_dynamic_path_value: @dynamic_path,
        )
      end

      private

      def before_render
        super
        with_loading unless loading?
      end
    end
  end
end
