require_relative "../../../view_component_test_case"

module RapidUI
  module Layout
    module Sidebar
      module Navigation
        class SectionTest < ViewComponentTestCase
          described_class Section

          test "renders a basic section" do
            render_inline build("Features")

            assert_selector ".sidebar-section"
            assert_selector ".sidebar-section button.sidebar-section-toggle", text: "Features"
          end

          test "renders expanded section by default" do
            render_inline build("Features", expanded: true)

            assert_selector ".sidebar-section"
            refute_selector ".sidebar-section.collapsed"
          end

          test "renders collapsed section" do
            render_inline build("Features", expanded: false)

            assert_selector ".sidebar-section.collapsed"
          end

          test "renders section with chevron icon" do
            render_inline build("Features")

            assert_selector ".sidebar-section button svg.expandable-chevron"
          end

          test "renders section with link items" do
            render_inline build("Features") do |section|
              section.with_link("Feature 1", "/feature-1")
              section.with_link("Feature 2", "/feature-2")
            end

            assert_selector ".sidebar-section a[href='/feature-1']", text: "Feature 1"
            assert_selector ".sidebar-section a[href='/feature-2']", text: "Feature 2"
          end

          test "renders section button with expandable action" do
            render_inline build("Features")

            assert_selector "button[data-action='click->expandable#toggle']"
          end

          test "renders with custom CSS class" do
            render_inline build("Features", class: "custom-section")

            assert_selector ".sidebar-section.custom-section"
          end

          test "renders section with active link" do
            render_inline build("Features") do |section|
              section.with_link("Feature 1", "/feature-1", active: true)
            end

            assert_selector ".sidebar-section a.active[href='/feature-1']", text: "Feature 1"
          end

          test "renders section with multiple links and badges" do
            render_inline build("Products") do |section|
              section.with_link("Product A", "/products/a") do |link|
                link.with_badge "New"
              end
              section.with_link("Product B", "/products/b")
            end

            assert_selector ".sidebar-section a[href='/products/a']", text: "Product A"
            assert_selector ".sidebar-section a[href='/products/a'] span.badge", text: "New"
            assert_selector ".sidebar-section a[href='/products/b']", text: "Product B"
          end

          test "renders with custom button" do
            render_inline build("Features") do |section|
              section.with_button("Custom Features", class: "custom-button")
            end

            assert_selector ".sidebar-section button.custom-button", text: "Custom Features"
          end

          test "renders collapsed section with links" do
            render_inline build("Features", expanded: false) do |section|
              section.with_link("Feature 1", "/feature-1")
            end

            assert_selector ".sidebar-section.collapsed"
            assert_selector ".sidebar-section a[href='/feature-1']", text: "Feature 1"
          end
        end
      end
    end
  end
end
