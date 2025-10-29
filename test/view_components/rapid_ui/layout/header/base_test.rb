require_relative "../../view_component_test_case"

module RapidUI
  module Layout
    module Header
      class BaseTest < ViewComponentTestCase
        described_class Base

        test "renders an empty header tag by default" do
          render_inline build
          assert_selector "header:empty"
        end

        test "renders left and right items" do
          render_inline build do |header|
            header.with_left.with_text("Left")
            header.with_right.with_text("Right")
          end

          assert_selector "header .header-left", text: "Left"
          assert_selector "header .header-right", text: "Right"
        end

        test "renders a text item" do
          render_inline build do |header|
            header.with_left.with_text("Header Text")
          end

          assert_selector "header .header-left", text: "Header Text"
        end

        test "renders a text link" do
          render_inline build do |header|
            header.with_left.with_text_link("Text Link", "/test")
          end

          assert_selector "header .header-left a.btn.btn-primary[href='/test']", text: "Text Link"
        end

        test "renders an icon link" do
          render_inline build do |header|
            header.with_left.with_icon_link("user", "/profile")
          end

          assert_selector "header .header-left a.btn.btn-primary[href='/profile'] svg"
        end

        test "renders a search item" do
          render_inline build do |header|
            header.with_left.with_search(path: "/search")
          end

          assert_selector "header .header-left"
        end

        test "renders a dropdown item" do
          render_inline build do |header|
            header.with_left do |left|
              left.with_dropdown do |dropdown|
                dropdown.with_button("Menu")
                dropdown.with_menu do |menu|
                  menu.with_item("Item 1", "#")
                end
              end
            end
          end

          assert_selector "header .header-left .dropdown"
          assert_selector "header .header-left .dropdown button", text: "Menu"
          assert_selector "header .header-left .dropdown .dropdown-menu-item", text: "Item 1"
        end

        test "renders multiple items in left section" do
          render_inline build do |header|
            header.with_left do |left|
              left.with_text("Text 1")
              left.with_text("Text 2")
              left.with_text_link("Link", "/test")
            end
          end

          assert_selector "header .header-left", text: "Text 1"
          assert_selector "header .header-left", text: "Text 2"
          assert_selector "header .header-left a[href='/test']", text: "Link"
        end

        test "renders multiple items in right section" do
          render_inline build do |header|
            header.with_right do |right|
              right.with_icon_link("user", "/profile")
              right.with_icon_link("settings", "/settings")
            end
          end

          assert_selector "header .header-right a[href='/profile'] svg"
          assert_selector "header .header-right a[href='/settings'] svg"
        end

        test "renders header with custom CSS class" do
          render_inline build(class: "custom-header")

          assert_selector "header.header.custom-header"
        end

        test "renders items with custom CSS classes" do
          render_inline build do |header|
            header.with_left(class: "custom-left") do |left|
              left.with_text("Left Text")
            end
            header.with_right(class: "custom-right") do |right|
              right.with_text("Right Text")
            end
          end

          assert_selector "header .header-left.custom-left", text: "Left Text"
          assert_selector "header .header-right.custom-right", text: "Right Text"
        end
      end
    end
  end
end
