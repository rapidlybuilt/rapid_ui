require_relative "../../view_component_test_case"

module RapidUI
  module Layout
    module Subheader
      class BaseTest < ViewComponentTestCase
        described_class Base

        test "renders a basic subheader" do
          render_inline build

          assert_selector "div.subheader:empty"
        end

        test "renders with custom CSS class" do
          render_inline build(class: "custom-subheader")

          assert_selector "div.subheader.custom-subheader"
        end

        test "renders a sidebar toggle button" do
          render_inline build do |subheader|
            subheader.with_sidebar_toggle_button(icon: "menu")
          end

          assert_selector "div.subheader button.btn[data-controller='toggle-button'] svg"
        end

        test "renders with breadcrumbs" do
          render_inline build do |subheader|
            subheader.with_breadcrumbs do |breadcrumbs|
              breadcrumbs.with_breadcrumb("Home", "/")
              breadcrumbs.with_breadcrumb("Products", "/products")
            end
          end

          assert_selector "div.subheader .subheader-breadcrumbs"
          assert_selector "div.subheader a[href='/']", text: "Home"
          assert_selector "div.subheader a[href='/products']", text: "Products"
        end

        test "renders a button" do
          render_inline build do |subheader|
            subheader.with_button("user", "/profile")
          end

          assert_selector "div.subheader .subheader-buttons a.btn.subheader-btn[href='/profile']"
        end

        test "renders button with custom variant" do
          render_inline build do |subheader|
            subheader.with_button("user", "/profile", variant: "primary")
          end

          assert_selector "div.subheader .subheader-buttons a.btn.btn-primary.subheader-btn[href='/profile']"
        end

        test "renders a toggle button in buttons section" do
          render_inline build do |subheader|
            subheader.with_toggle_button(icon: "settings")
          end

          assert_selector "div.subheader .subheader-buttons button.btn svg"
        end

        test "renders circular toggle button in buttons section" do
          render_inline build do |subheader|
            subheader.with_toggle_button(icon: "settings", circular: true)
          end

          assert_selector "div.subheader .subheader-buttons button.btn.btn-circular.size-8"
        end

        test "renders multiple buttons" do
          render_inline build do |subheader|
            subheader.with_button("user", "/profile")
            subheader.with_button("settings", "/settings")
          end

          assert_selector "div.subheader .subheader-buttons a[href='/profile']"
          assert_selector "div.subheader .subheader-buttons a[href='/settings']"
        end

        test "renders sidebar toggle, breadcrumbs, and buttons together" do
          render_inline build do |subheader|
            subheader.with_sidebar_toggle_button(icon: "menu")
            subheader.with_breadcrumbs do |breadcrumbs|
              breadcrumbs.with_breadcrumb("Home", "/")
              breadcrumbs.with_breadcrumb("Products", "/products")
            end
            subheader.with_button("user", "/profile")
            subheader.with_button("settings", "/settings")
          end

          assert_selector "div.subheader button.btn svg"
          assert_selector "div.subheader .subheader-breadcrumbs a[href='/']", text: "Home"
          assert_selector "div.subheader .subheader-breadcrumbs a[href='/products']", text: "Products"
          assert_selector "div.subheader .subheader-buttons a[href='/profile']"
          assert_selector "div.subheader .subheader-buttons a[href='/settings']"
        end

        test "renders buttons with mixed button and toggle_button types" do
          target = Struct.new(:id).new("settings_panel")

          render_inline build do |subheader|
            subheader.with_button("user", "/profile")
            subheader.with_toggle_button(icon: "settings", target: target)
          end

          assert_selector "div.subheader .subheader-buttons a.btn[href='/profile']"
          assert_selector "div.subheader .subheader-buttons button.btn[data-toggle-button-target-value='settings_panel']"
        end

        test "does not render subheader-buttons container when no buttons" do
          render_inline build do |subheader|
            subheader.with_sidebar_toggle_button(icon: "menu")
          end

          assert_no_selector "div.subheader .subheader-buttons"
        end
      end
    end
  end
end
