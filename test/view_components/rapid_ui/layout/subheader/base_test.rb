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

        test "renders with left and right sections by default" do
          render_inline build do |subheader|
            subheader.with_left
            subheader.with_right
          end

          assert_selector "div.subheader .subheader-left"
          assert_selector "div.subheader .subheader-right"
        end

        test "renders with custom CSS class" do
          render_inline build(class: "custom-subheader")

          assert_selector "div.subheader.custom-subheader"
        end

        test "renders left section with button" do
          render_inline build do |subheader|
            subheader.with_left do |left|
              left.with_button("user", "/profile")
            end
          end

          assert_selector "div.subheader .subheader-left a.btn.subheader-btn[href='/profile']"
          assert_selector "div.subheader .subheader-left a svg"
        end

        test "renders right section with button" do
          render_inline build do |subheader|
            subheader.with_right do |right|
              right.with_button("settings", "/settings")
            end
          end

          assert_selector "div.subheader .subheader-right a.btn.subheader-btn[href='/settings']"
        end

        test "renders button with custom variant" do
          render_inline build do |subheader|
            subheader.with_left do |left|
              left.with_button("user", "/profile", variant: "primary")
            end
          end

          assert_selector "div.subheader .subheader-left a.btn.btn-primary[href='/profile']"
        end

        test "renders sidebar toggle button" do
          render_inline build do |subheader|
            subheader.with_left do |left|
              left.with_sidebar_toggle_button(icon: "menu")
            end
          end

          assert_selector "div.subheader .subheader-left button.btn"
          assert_selector "div.subheader .subheader-left button svg"
        end

        test "renders circular sidebar toggle button" do
          render_inline build do |subheader|
            subheader.with_left do |left|
              left.with_sidebar_toggle_button(icon: "menu", circular: true)
            end
          end

          assert_selector "div.subheader .subheader-left button.btn.btn-circular.size-8"
        end

        test "renders with breadcrumbs" do
          # TODO: determine why with_ methods don't work here
          render_inline build do |subheader|
            subheader.build_left do |left|
              left.build_breadcrumbs do |breadcrumbs|
                breadcrumbs.build_breadcrumb("Home", "/")
                breadcrumbs.build_breadcrumb("Products", "/products")
              end
            end
          end

          assert_selector "div.subheader .subheader-breadcrumbs"
          assert_selector "div.subheader .subheader-breadcrumbs a[href='/']", text: "Home"
          assert_selector "div.subheader .subheader-breadcrumbs a[href='/products']", text: "Products"
        end

        test "renders breadcrumbs using delegate method" do
          # TODO: determine why with_ methods don't work here
          render_inline build do |subheader|
            subheader.build_left do |left|
              left.build_breadcrumbs do |breadcrumbs|
                breadcrumbs.build_breadcrumb("Home", "/")
                breadcrumbs.build_breadcrumb("About", "/about")
              end
            end
          end

          assert_selector "div.subheader .subheader-breadcrumbs a[href='/']", text: "Home"
          assert_selector "div.subheader .subheader-breadcrumbs a[href='/about']", text: "About"
        end

        test "renders multiple items in left section" do
          # TODO: determine why with_ methods don't work here
          render_inline build do |subheader|
            subheader.build_left do |left|
              left.with_sidebar_toggle_button(icon: "menu")
              left.build_breadcrumbs do |breadcrumbs|
                breadcrumbs.build_breadcrumb("Home", "/")
              end
            end
          end

          assert_selector "div.subheader .subheader-left button"
          assert_selector "div.subheader .subheader-left .subheader-breadcrumbs"
        end

        test "renders multiple items in right section" do
          render_inline build do |subheader|
            subheader.with_right do |right|
              right.with_button("user", "/profile")
              right.with_button("settings", "/settings")
            end
          end

          assert_selector "div.subheader .subheader-right a[href='/profile']"
          assert_selector "div.subheader .subheader-right a[href='/settings']"
        end

        test "renders left and right sections with custom CSS classes" do
          render_inline build do |subheader|
            subheader.with_left(class: "custom-left") do |left|
              left.with_button("x", "/")
            end
            subheader.with_right(class: "custom-right") do |right|
              right.with_button("user", "/profile")
            end
          end

          assert_selector "div.subheader .subheader-left.custom-left"
          assert_selector "div.subheader .subheader-right.custom-right"
        end
      end
    end
  end
end
