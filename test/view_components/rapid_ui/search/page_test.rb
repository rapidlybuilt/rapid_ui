require "test_helper"

module RapidUI
  module Search
    class PageTest < ViewComponentTestCase
      described_class Page

      test "renders search page with controller and paths" do
        render_inline build(
          static_path: "/search",
          dynamic_path: "/search",
          search_path: "/search",
        )

        assert_selector "[data-controller='search-page']"
        assert_selector "[data-search-page-static-path-value='/search']"
        assert_selector "[data-search-page-dynamic-path-value='/search']"
      end

      test "renders title from i18n" do
        render_inline build(
          static_path: "/search",
          dynamic_path: "/search",
          search_path: "/search",
        )

        assert_selector "h1", text: "Search"
      end

      test "renders form with search_path as action" do
        render_inline build(
          static_path: "/search",
          dynamic_path: "/search",
          search_path: "/search",
        )

        assert_selector "form[action='/search'][method='get']"
      end

      test "renders search input with placeholder and submit button" do
        render_inline build(
          static_path: "/search",
          dynamic_path: "/search",
          search_path: "/search",
        )

        assert_selector "input[placeholder='Search...'][data-search-page-target='input']"
        assert_selector "input[type='submit'][value='Search']"
      end

      test "renders query container with query text" do
        render_inline build(
          static_path: "/search",
          dynamic_path: "/search",
          search_path: "/search",
        ) do |page|
          page.query = "test query"
        end

        assert_selector "[data-search-page-target='query']", text: "test query"
      end

      test "renders results when provided" do
        render_inline build(
          static_path: "/search",
          dynamic_path: "/search",
          search_path: "/search",
        ) do |page|
          page.with_result(title: "First", url: "/first", description: "First result")
          page.with_result(title: "Second", url: "/second", description: "Second result")
        end

        assert_selector "[data-search-page-target='results'] .search-page-result-item", count: 2
        assert_selector ".search-result-title", text: "First"
        assert_selector ".search-result-title", text: "Second"
      end

      test "renders empty results text" do
        render_inline build(
          static_path: "/search",
          dynamic_path: "/search",
          search_path: "/search",
        )

        assert_selector "[data-search-page-target='emptyResults']", text: "No results found"
      end

      test "renders loading slot by default" do
        render_inline build(
          static_path: "/search",
          dynamic_path: "/search",
          search_path: "/search",
        )

        assert_selector "[data-search-page-target='loading']"
        assert_selector "[data-search-page-target='loading'] svg"
      end

      test "renders with custom loading slot" do
        render_inline build(
          static_path: "/search",
          dynamic_path: "/search",
          search_path: "/search",
        ) do |page|
          page.with_loading(class: "custom-loader")
        end

        assert_selector "[data-search-page-target='loading'] svg.custom-loader"
      end

      test "renders with custom CSS class" do
        render_inline build(
          static_path: "/search",
          dynamic_path: "/search",
          search_path: "/search",
          class: "custom-search-page",
        )

        assert_selector ".search-page.custom-search-page"
      end

      test "renders result template for client-side rendering" do
        render_inline build(
          static_path: "/search",
          dynamic_path: "/search",
          search_path: "/search",
        )

        assert_selector "template[data-search-page-target='resultTemplate']", visible: false
      end
    end
  end
end
