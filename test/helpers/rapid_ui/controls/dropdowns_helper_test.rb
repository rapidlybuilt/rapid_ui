require_relative "../helper_test_case"

module RapidUI
  module Controls
    class DropdownsHelperTest < HelperTestCase
      include RapidUI::Controls::DropdownsHelper

      test "new_dropdown returns a Dropdown component" do
        dropdown = new_dropdown(variant: "primary")
        assert_instance_of Dropdown, dropdown
      end

      test "new_dropdown accepts content as arguments" do
        dropdown = new_dropdown("Test Content", variant: "primary")
        html = render(dropdown)
        assert_match(/Test Content/, html)
      end

      test "new_dropdown accepts block for configuration" do
        dropdown = new_dropdown(variant: "primary") do |d|
          d.with_button("Test Button")
          d.with_menu do |menu|
            menu.with_item("Item 1", "/path1")
          end
        end

        html = render(dropdown)
        assert_match(/Test Button/, html)
        assert_match(/Item 1/, html)
      end

      test "dropdown helper with button children" do
        render_inline dropdown("Dropdown Button", variant: "primary")
        assert_selector "div.dropdown.dropdown-primary[data-controller='dropdown']"
        assert_selector "button.btn.btn-primary", text: "Dropdown Button"
      end

      test "dropdown helper with block for menu" do
        html = dropdown("Actions", variant: "primary") do |menu|
          menu.with_item("Edit", "/edit")
          menu.with_item("Delete", "/delete")
        end

        render_inline html
        assert_selector "div.dropdown.dropdown-primary"
        assert_selector "button.btn.btn-primary", text: "Actions"
        assert_selector "a.dropdown-menu-item", text: "Edit"
        assert_selector "a.dropdown-menu-item", text: "Delete"
      end

      test "dynamically generated methods for variants" do
        dropdown = new_primary_dropdown
        assert_equal "primary", dropdown.variant

        render_inline primary_dropdown("Primary Dropdown")
        assert_selector "div.dropdown.dropdown-primary"
        assert_selector "button.btn.btn-primary", text: "Primary Dropdown"
      end
    end
  end
end
