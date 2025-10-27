require_relative "../../view_component_test_case"

module RapidUI
  module Layout
    module Subheader
      class BreadcrumbTest < ViewComponentTestCase
        described_class Breadcrumb

        test "renders a breadcrumb with path" do
          render_inline(build("Home", "/"))

          assert_selector "a.typography-link[href='/']", text: "Home"
        end

        test "renders a breadcrumb without path as plain text" do
          render_inline(build("Current Page", nil))

          assert_text "Current Page"
          refute_selector "a"
        end

        test "renders a breadcrumb without path using blank string" do
          render_inline(build("Current Page", ""))

          assert_text "Current Page"
          refute_selector "a"
        end

        test "renders breadcrumb with custom CSS class" do
          render_inline(build("Home", "/", class: "custom-breadcrumb"))

          assert_selector "a.typography-link.custom-breadcrumb[href='/']", text: "Home"
        end

        test "renders multiple breadcrumbs with different paths" do
          render_inline(build("Products", "/products"))

          assert_selector "a[href='/products']", text: "Products"
        end
      end

      class BreadcrumbContainerTest < ViewComponentTestCase
        described_class Breadcrumb::Container

        test "renders breadcrumb container" do
          render_inline(build)

          assert_selector "div.subheader-breadcrumbs"
        end

        test "renders container with multiple breadcrumbs" do
          render_inline(build) do |container|
            container.with_breadcrumb("Home", "/")
            container.with_breadcrumb("Products", "/products")
            container.with_breadcrumb("Current")
          end

          assert_selector "div.subheader-breadcrumbs"
          assert_selector "div.subheader-breadcrumbs a[href='/']", text: "Home"
          assert_selector "div.subheader-breadcrumbs a[href='/products']", text: "Products"
          assert_text "Current"
        end

        test "renders container with default separator" do
          render_inline(build) do |container|
            container.with_breadcrumb("Home", "/")
            container.with_breadcrumb("Products", "/products")
          end

          assert_selector "div.subheader-breadcrumbs"
          assert_match(%(<span class="px-3px">&raquo;</span>), rendered_content)
        end

        test "renders container with custom separator" do
          render_inline(build(separator: " / ")) do |container|
            container.with_breadcrumb("Home", "/")
            container.with_breadcrumb("Products", "/products")
          end

          assert_selector "div.subheader-breadcrumbs"
          assert_match(%r{/}, rendered_content)
        end

        test "renders container with custom CSS class" do
          render_inline(build(class: "custom-breadcrumbs"))

          assert_selector "div.subheader-breadcrumbs.custom-breadcrumbs"
        end

        test "renders empty container" do
          render_inline(build)

          assert_selector "div.subheader-breadcrumbs"
        end

        test "renders container with single breadcrumb" do
          render_inline(build) do |container|
            container.with_breadcrumb("Home", "/")
          end

          assert_selector "div.subheader-breadcrumbs a[href='/']", text: "Home"
          # No separator should be visible with single breadcrumb
        end

        test "renders container with mixed link and text breadcrumbs" do
          render_inline(build) do |container|
            container.with_breadcrumb("Home", "/")
            container.with_breadcrumb("Products", "/products")
            container.with_breadcrumb("Electronics", "/products/electronics")
            container.with_breadcrumb("Laptop")
          end

          assert_selector "div.subheader-breadcrumbs a[href='/']", text: "Home"
          assert_selector "div.subheader-breadcrumbs a[href='/products']", text: "Products"
          assert_selector "div.subheader-breadcrumbs a[href='/products/electronics']", text: "Electronics"
          assert_text "Laptop"
          refute_selector "a", text: "Laptop"
        end

        private

        def build_container(*args, **kwargs, &block)
          Breadcrumb::Container.new(*args, factory: factory, **kwargs, &block)
        end
      end
    end
  end
end
