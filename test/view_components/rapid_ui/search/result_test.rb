require "test_helper"

module RapidUI
  module Search
    class ResultTest < ViewComponentTestCase
      described_class Result

      test "renders with title and description" do
        render_inline build(
          title: "Example Page",
          url: "/example",
          description: "An example description",
        )

        assert_selector "a.search-page-result-item"
        assert_selector ".search-result-title", text: "Example Page"
        assert_selector ".search-result-description", text: "An example description"
      end

      test "renders with data attributes for url, title, and description" do
        render_inline build(
          title: "Result Title",
          url: "/results/1",
          description: "Result description",
        )

        assert_selector "[data-result-url='/results/1']"
        assert_selector "[data-result-title='Result Title']"
        assert_selector "[data-result-description='Result description']"
      end

      test "renders with nil description" do
        render_inline build(title: "Title Only", url: "/path")

        assert_selector ".search-result-title", text: "Title Only"
        assert_selector ".search-result-description", text: ""
      end

      test "renders with custom CSS class" do
        render_inline build(
          title: "Title",
          url: "/path",
          class: "custom-result",
        )

        assert_selector "a.search-page-result-item.custom-result"
      end
    end
  end
end
