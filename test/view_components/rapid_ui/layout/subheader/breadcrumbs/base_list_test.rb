require_relative "../../../view_component_test_case"

module RapidUI
  module Layout
    module Subheader
      module Breadcrumbs
        class BaseListTest < ViewComponentTestCase
          described_class BaseList

          test "initializes with default separator" do
            component = build

            assert_equal BaseList::SEPARATOR, component.separator
          end

          test "initializes with custom separator" do
            component = build(separator: " / ")

            assert_equal " / ", component.separator
          end

          test "builds breadcrumb and adds to array" do
            component = build
            component.with_breadcrumb("Home", "/")
            component.with_breadcrumb("Products", "/products")

            assert_equal 2, component.array.size
            assert_equal "Home", component.array.first.name
            assert_equal "/", component.array.first.path
          end

          test "renders breadcrumb with path as link" do
            component = build
            breadcrumb = component.array.new("Home", "/")
            rendered = component.render_breadcrumb(breadcrumb)

            assert_match %r{<a href="/">Home</a>}, rendered
          end

          test "renders breadcrumb without path as span" do
            component = build
            breadcrumb = component.array.new("Current Page", nil)
            rendered = component.render_breadcrumb(breadcrumb)

            assert_match %r{<span>Current Page</span>}, rendered
          end
        end
      end
    end
  end
end
