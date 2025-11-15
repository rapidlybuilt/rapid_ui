require_relative "../../../view_component_test_case"

module RapidUI
  module Layout
    module Subheader
      module Breadcrumbs
        class DropdownListTest < ViewComponentTestCase
          described_class DropdownList

          test "renders dropdown with last breadcrumb as button" do
            array = Breadcrumbs::Array.new
            array.build("Home", "/")
            array.build("Products", "/products")
            array.build("Current Page", "/current")

            render_inline build(array)

            assert_selector "div.subheader-breadcrumbs"
            assert_text "Current Page"
          end

          test "renders all breadcrumbs in dropdown menu" do
            array = Breadcrumbs::Array.new
            array.build("Home", "/")
            array.build("Products", "/products")
            array.build("Current Page")

            render_inline build(array)

            assert_selector ".dropdown-menu .dropdown-menu-item[href='/']", text: "Home"
            assert_selector ".dropdown-menu .dropdown-menu-item[href='/products']", text: "Products"
            assert_selector ".dropdown-menu .dropdown-menu-item", text: "Current Page"
          end

          test "renders empty dropdown" do
            array = Breadcrumbs::Array.new

            render_inline build(array)

            assert_selector "div.subheader-breadcrumbs"
          end

          test "renders with custom CSS class" do
            array = Breadcrumbs::Array.new
            array.build("Home", "/")

            render_inline build(array, class: "custom-dropdown")

            assert_selector "div.subheader-breadcrumbs.custom-dropdown"
          end
        end
      end
    end
  end
end
