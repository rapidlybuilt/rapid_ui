require_relative "../../../view_component_test_case"

module RapidUI
  module Layout
    module Subheader
      module Breadcrumbs
        class FullListTest < ViewComponentTestCase
          described_class FullList

          test "renders full list of breadcrumbs" do
            array = Breadcrumbs::Array.new
            array.build("Home", "/")
            array.build("Products", "/products")
            array.build("Current Page")

            render_inline build(array)

            assert_selector "div.subheader-breadcrumbs"
            assert_selector "a[href='/']", text: "Home"
            assert_selector "a[href='/products']", text: "Products"
            assert_text "Current Page"
            refute_selector "a", text: "Current Page"
          end

          test "renders with default separator" do
            array = Breadcrumbs::Array.new
            array.build("Home", "/")
            array.build("Products", "/products")

            render_inline build(array)

            assert_match(%(<span class="px-3px">&raquo;</span>), rendered_content)
          end

          test "renders with custom separator" do
            array = Breadcrumbs::Array.new
            array.build("Home", "/")
            array.build("Products", "/products")

            render_inline build(array, separator: " / ")

            assert_match(%r{/}, rendered_content)
          end

          test "renders empty list" do
            array = Breadcrumbs::Array.new

            render_inline build(array)

            assert_selector "div.subheader-breadcrumbs"
          end

          test "renders single breadcrumb without separator" do
            array = Breadcrumbs::Array.new
            array.build("Home", "/")

            render_inline build(array)

            assert_selector "a[href='/']", text: "Home"
            refute_match(%(<span class="px-3px">&raquo;</span>), rendered_content)
          end

          test "renders with custom CSS class" do
            array = Breadcrumbs::Array.new

            render_inline build(array, class: "custom-list")

            assert_selector "div.subheader-breadcrumbs.custom-list"
          end
        end
      end
    end
  end
end
