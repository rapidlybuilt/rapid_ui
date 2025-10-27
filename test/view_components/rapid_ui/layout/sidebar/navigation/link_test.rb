require_relative "../../../view_component_test_case"

module RapidUI
  module Layout
    module Sidebar
      module Navigation
        class LinkTest < ViewComponentTestCase
          described_class Link

          test "renders a basic link" do
            render_inline(build("Home", "/"))

            assert_selector "a.sidebar-link.sidebar-nav-link[href='/']", text: "Home"
          end

          test "renders link with custom path" do
            render_inline(build("About", "/about"))

            assert_selector "a.sidebar-link.sidebar-nav-link[href='/about']", text: "About"
          end

          test "renders active link" do
            render_inline(build("Home", "/", active: true))

            assert_selector "a.sidebar-link.sidebar-nav-link.active[href='/']", text: "Home"
          end

          test "renders inactive link by default" do
            render_inline(build("Home", "/"))

            assert_selector "a.sidebar-link.sidebar-nav-link[href='/']", text: "Home"
            refute_selector "a.active"
          end

          test "renders with badge" do
            render_inline(build("Home", "/")) do |link|
              link.with_badge do
                "New"
              end
            end

            assert_selector "a.sidebar-link[href='/']"
            assert_selector "a.sidebar-link span.badge", text: "New"
          end

          test "renders with custom CSS class" do
            render_inline(build("Home", "/", class: "custom-link"))

            assert_selector "a.sidebar-link.sidebar-nav-link.custom-link[href='/']", text: "Home"
          end

          test "renders active link with badge" do
            render_inline(build("Home", "/", active: true)) do |link|
              link.with_badge do
                "5"
              end
            end

            assert_selector "a.sidebar-link.sidebar-nav-link.active[href='/']"
            assert_selector "a span.badge", text: "5"
          end

          test "renders with custom content" do
            render_inline(build("Home", "/")) do
              "Custom Content"
            end

            assert_selector "a.sidebar-link[href='/']", text: "Custom Content"
          end

          test "renders title by default without block" do
            render_inline(build("Dashboard", "/dashboard"))

            assert_selector "a.sidebar-link[href='/dashboard']", text: "Dashboard"
          end
        end
      end
    end
  end
end
