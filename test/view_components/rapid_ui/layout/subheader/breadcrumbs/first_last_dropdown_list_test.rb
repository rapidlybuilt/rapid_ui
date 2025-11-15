require_relative "../../../view_component_test_case"

module RapidUI
  module Layout
    module Subheader
      module Breadcrumbs
        class FirstLastDropdownListTest < ViewComponentTestCase
          described_class FirstLastDropdownList

          test "renders first and last breadcrumb with dropdown in middle" do
            array = Breadcrumbs::Array.new
            array.build("Home", "/")
            array.build("Products", "/products")
            array.build("Electronics", "/electronics")
            array.build("Current Page")

            render_inline build(array)

            assert_selector "div.subheader-breadcrumbs"
            assert_selector "a[href='/']", text: "Home"
            assert_text "Current Page"
            assert_text "..."
          end

          test "renders middle breadcrumbs in dropdown menu" do
            array = Breadcrumbs::Array.new
            array.build("Home", "/")
            array.build("Products", "/products")
            array.build("Electronics", "/electronics")
            array.build("Current Page")

            render_inline build(array)

            assert_selector "a[href='/']", text: "Home"
            assert_selector ".dropdown-menu .dropdown-menu-item[href='/products']", text: "Products"
            assert_selector ".dropdown-menu .dropdown-menu-item[href='/electronics']", text: "Electronics"
            assert_selector "span", text: "Current Page"

            # the first and last breadcrumbs are outside the dropdown menu
            assert_no_selector ".dropdown-menu a[href='/']", text: "Home"
            assert_no_selector ".dropdown-menu span", text: "Current Page"
          end

          test "renders with separator between elements" do
            array = Breadcrumbs::Array.new
            array.build("Home", "/")
            array.build("Products", "/products")
            array.build("Current Page")

            render_inline build(array)

            assert_match(%(<span class="px-3px">&raquo;</span>), rendered_content)
          end

          test "renders with custom separator" do
            array = Breadcrumbs::Array.new
            array.build("Home", "/")
            array.build("Products", "/products")
            array.build("Current Page")

            render_inline build(array, separator: " / ")

            assert_match(%r{/}, rendered_content)
          end

          test "renders empty list" do
            array = Breadcrumbs::Array.new

            render_inline build(array)

            assert_selector "div.subheader-breadcrumbs"
          end

          test "renders with custom CSS class" do
            array = Breadcrumbs::Array.new
            array.build("Home", "/")
            array.build("Current Page")

            render_inline build(array, class: "custom-first-last")

            assert_selector "div.subheader-breadcrumbs.custom-first-last"
          end
        end
      end
    end
  end
end
