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

      renders_one :loading, ->(**kwargs) do
        build(RapidUI::Icon, "loader", spin: true, **kwargs)
      end

      def initialize(**kwargs)
        super(
          **kwargs,
          class: merge_classes("search-page", kwargs[:class]),
        )

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
        {
          controller: "search-page",
          search_page_static_path_value: @static_path,
          search_page_dynamic_path_value: @dynamic_path,
        }
      end

      private

      def before_render
        super
        with_loading unless loading?
      end
    end
  end
end
