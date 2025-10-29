require_relative "../../../view_component_test_case"

module RapidUI
  module Layout
    module Sidebar
      module Navigation
        class BaseTest < ViewComponentTestCase
          described_class Base

          test "renders a basic navigation" do
            render_inline build

            assert_selector "nav.sidebar-nav"
          end

          test "renders with custom CSS class" do
            render_inline build(class: "custom-nav")

            assert_selector "nav.sidebar-nav.custom-nav"
          end

          test "renders links" do
            render_inline build do |nav|
              nav.with_link("Home", "/")
              nav.with_link("About", "/about")
            end

            assert_selector "nav.sidebar-nav a[href='/']", text: "Home"
            assert_selector "nav.sidebar-nav a[href='/about']", text: "About"
          end

          test "renders with section items" do
            render_inline build do |nav|
              nav.with_section("Features") do |section|
                section.with_link("Feature 1", "/feature-1")
              end
            end

            assert_selector "nav.sidebar-nav .sidebar-section"
            assert_selector "nav.sidebar-nav .sidebar-section a[href='/feature-1']", text: "Feature 1"
          end

          test "renders with multiple items" do
            render_inline build do |nav|
              nav.with_link("Home", "/")
              nav.with_section("Products") do |section|
                section.with_link("Product A", "/products/a")
              end
              nav.with_link("Contact", "/contact")
            end

            assert_selector "nav.sidebar-nav a[href='/']", text: "Home"
            assert_selector "nav.sidebar-nav .sidebar-section"
            assert_selector "nav.sidebar-nav a[href='/contact']", text: "Contact"
          end

          test "renders empty navigation" do
            render_inline build

            assert_selector "nav.sidebar-nav"
          end

          test "renders with custom tag name" do
            render_inline build(tag_name: :div)

            assert_selector "div.sidebar-nav"
          end
        end
      end
    end
  end
end
