require_relative "../../../view_component_test_case"

module RapidUI
  module Layout
    module Subheader
      module Breadcrumbs
        class ArrayTest < ViewComponentTestCase
          test "creates a new breadcrumb item" do
            array = Breadcrumbs::Array.new
            item = array.new("Home", "/")

            assert_equal "Home", item.name
            assert_equal "/", item.path
          end

          test "creates breadcrumb item without path" do
            array = Breadcrumbs::Array.new
            item = array.new("Current Page")

            assert_equal "Current Page", item.name
            assert_nil item.path
          end

          test "builds and adds breadcrumb to array" do
            array = Breadcrumbs::Array.new
            array.build("Home", "/")
            array.build("Products", "/products")

            assert_equal 2, array.size
            assert_equal "Home", array.first.name
            assert_equal "Products", array.last.name
          end

          test "builds breadcrumb without path" do
            array = Breadcrumbs::Array.new
            array.build("Current Page")

            assert_equal 1, array.size
            assert_equal "Current Page", array.first.name
            assert_nil array.first.path
          end
        end
      end
    end
  end
end
