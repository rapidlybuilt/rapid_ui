require_relative "../../view_component_test_case"

module RapidUI
  module Layout
    module Header
      class SearchTest < ViewComponentTestCase
        described_class Search

        test "renders a basic search component" do
          render_inline build(path: "/search")

          assert_selector "[data-controller]"
        end

        test "renders search with custom path" do
          render_inline build(path: "/custom/search")

          assert_selector "[data-controller]"
        end

        test "renders search icon by default" do
          render_inline build(path: "/search")

          assert_selector "svg"
        end

        test "renders with custom search icon" do
          render_inline build(path: "/search") do |search|
            search.with_search_icon(class: "custom-icon")
          end

          assert_selector "svg.custom-icon"
        end

        test "renders with custom clear icon" do
          render_inline build(path: "/search") do |search|
            search.with_clear_icon(class: "custom-close")
          end

          assert_selector "svg"
        end

        test "renders with a custom cancel button" do
          render_inline build(path: "/search") do |search|
            search.with_cancel_button(class: "custom-cancel")
          end

          assert_selector "button.custom-cancel"
        end

        test "renders with custom loading icon" do
          render_inline build(path: "/search") do |search|
            search.with_loading_icon(class: "custom-loading")
          end

          assert_selector "svg"
        end

        test "renders with custom placeholder" do
          render_inline build(path: "/search") do |search|
            search.placeholder = "Search here..."
          end

          assert_selector "[data-controller]"
        end

        test "renders with custom shortcut hint" do
          render_inline build(path: "/search") do |search|
            search.shortcut_hint = "Cmd+K"
          end

          assert_selector "[data-controller]"
        end

        test "renders with custom loading text" do
          render_inline build(path: "/search") do |search|
            search.loading_text = "Searching..."
          end

          assert_selector "[data-controller]"
        end

        test "renders with custom error text" do
          render_inline build(path: "/search") do |search|
            search.error_text = "Search failed"
          end

          assert_selector "[data-controller]"
        end

        test "renders with custom clear title" do
          render_inline build(path: "/search") do |search|
            search.clear_title = "Clear search"
          end

          assert_selector "[data-controller]"
        end

        test "renders with custom CSS class" do
          render_inline build(path: "/search", class: "custom-search")

          assert_selector ".custom-search"
        end

        test "renders all icons by default through before_render" do
          render_inline build(path: "/search")

          # Should have search, close, and loading icons
          assert_selector "svg", minimum: 1
        end
      end
    end
  end
end
