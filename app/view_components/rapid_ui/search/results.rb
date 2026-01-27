module RapidUI
  module Search
    class Results < ApplicationComponent
      attr_accessor :results
      attr_accessor :empty_results_text # TODO: component instead of just a string
      attr_accessor :skip_empty_results

      renders_many :items, Result

      # @param results [Array<Hash>] Array of result hashes with :title, :url, :description
      # @param empty_results_text [String] Text to show when no results (default: "No results found")
      # @param skip_empty_results [Boolean] Whether to show "no results" message when empty (default: false)
      def initialize(results: [], empty_results_text: nil, skip_empty_results: false, **kwargs)
        super(**kwargs)

        @results = results
        @empty_results_text = empty_results_text || "No results found"
        @skip_empty_results = skip_empty_results
      end

      def before_render
        # Convert result hashes to Result components if not already rendered via slot
        if items.empty? && results.any?
          results.each do |result|
            with_item(
              title: result[:title] || result["title"],
              url: result[:url] || result["url"],
              description: result[:description] || result["description"]
            )
          end
        end
      end

      def call
        if items.any?
          safe_join(items)
        elsif skip_empty_results
          tag.div(class: "search-no-results") do
            tag.span(empty_results_text)
          end
        end
      end
    end
  end
end
