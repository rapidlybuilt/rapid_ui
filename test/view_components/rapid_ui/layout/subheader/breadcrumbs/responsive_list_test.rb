require_relative "../../../view_component_test_case"

module RapidUI
  module Layout
    module Subheader
      module Breadcrumbs
        class ResponsiveListTest < ViewComponentTestCase
          described_class ResponsiveList

          test "renders all three breadcrumb list variants" do
            array = Breadcrumbs::Array.new
            array.build("Home", "/")
            array.build("Products", "/products")
            array.build("Current Page")

            render_inline build(array)

            assert_selector "div.subheader-breadcrumbs"
            assert_selector ".subheader-breadcrumbs-dropdown-list"
            assert_selector ".subheader-breadcrumbs-first-last-dropdown-list"
            assert_selector ".subheader-breadcrumbs-full-list"
          end

          test "hides non-default modes by default" do
            array = Breadcrumbs::Array.new
            array.build("Home", "/")
            array.build("Products", "/products")

            render_inline build(array)

            assert_selector ".subheader-breadcrumbs-dropdown-list.hidden"
            assert_selector ".subheader-breadcrumbs-first-last-dropdown-list.hidden"
            assert_selector ".subheader-breadcrumbs-full-list.hidden"
          end

          test "shows dropdown-list mode when specified" do
            array = Breadcrumbs::Array.new
            array.build("Home", "/")
            array.build("Products", "/products")

            render_inline build(array, mode: "dropdown-list")

            refute_selector ".subheader-breadcrumbs-dropdown-list.hidden"
            assert_selector ".subheader-breadcrumbs-first-last-dropdown-list.hidden"
            assert_selector ".subheader-breadcrumbs-full-list.hidden"
          end

          test "shows first-last-dropdown-list mode when specified" do
            array = Breadcrumbs::Array.new
            array.build("Home", "/")
            array.build("Products", "/products")

            render_inline build(array, mode: "first-last-dropdown-list")

            assert_selector ".subheader-breadcrumbs-dropdown-list.hidden"
            refute_selector ".subheader-breadcrumbs-first-last-dropdown-list.hidden"
            assert_selector ".subheader-breadcrumbs-full-list.hidden"
          end

          test "shows full-list mode when specified" do
            array = Breadcrumbs::Array.new
            array.build("Home", "/")
            array.build("Products", "/products")

            render_inline build(array, mode: "full-list")

            assert_selector ".subheader-breadcrumbs-dropdown-list.hidden"
            assert_selector ".subheader-breadcrumbs-first-last-dropdown-list.hidden"
            refute_selector ".subheader-breadcrumbs-full-list.hidden"
          end

          test "adds breadcrumbs controller data attribute" do
            array = Breadcrumbs::Array.new
            array.build("Home", "/")

            render_inline build(array)

            assert_selector "div[data-controller='breadcrumbs']"
          end

          test "adds target data attributes to child lists" do
            array = Breadcrumbs::Array.new
            array.build("Home", "/")

            render_inline build(array)

            assert_selector "[data-breadcrumbs-target='dropdownList']"
            assert_selector "[data-breadcrumbs-target='firstLastDropdownList']"
            assert_selector "[data-breadcrumbs-target='fullList']"
          end

          test "renders empty list" do
            array = Breadcrumbs::Array.new

            render_inline build(array)

            assert_selector "div.subheader-breadcrumbs"
          end

          test "renders with custom CSS class" do
            array = Breadcrumbs::Array.new
            array.build("Home", "/")

            render_inline build(array, class: "custom-responsive")

            assert_selector "div.subheader-breadcrumbs.custom-responsive"
          end

          test "passes custom separator to child lists" do
            array = Breadcrumbs::Array.new
            array.build("Home", "/")
            array.build("Products", "/products")

            render_inline build(array, separator: " / ")

            assert_match(%r{/}, rendered_content)
          end
        end
      end
    end
  end
end
