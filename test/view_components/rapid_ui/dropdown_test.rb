require_relative "view_component_test_case"

module RapidUI
  class DropdownTest < ViewComponentTestCase
    described_class Dropdown

    test "renders a basic dropdown" do
      render_inline(build(variant: "primary")) do |dropdown|
        dropdown.with_button("Dropdown")

        dropdown.with_menu do |menu|
          menu.with_item("Item 1", "/path1")
          menu.with_item("Item 2", "/path2")
        end
      end

      assert_selector "div.dropdown.dropdown-primary[data-controller='dropdown']"
      assert_selector "button.btn.btn-primary[data-action='click->dropdown#toggle']", text: "Dropdown"
      assert_selector "div.dropdown-menu"
      assert_selector "a.dropdown-menu-item", text: "Item 1"
      assert_selector "a.dropdown-menu-item", text: "Item 2"
    end

    test "renders dropdown with variant" do
      render_inline(build(variant: "secondary")) do |dropdown|
        dropdown.with_button("Secondary")
      end

      assert_selector "div.dropdown.dropdown-secondary"
      assert_selector "button.btn.btn-secondary", text: "Secondary"
    end

    test "renders dropdown with size" do
      render_inline(build(variant: "primary", size: "lg")) do |dropdown|
        dropdown.with_button("Large")
      end

      assert_selector "div.dropdown.dropdown-primary.dropdown-lg"
      assert_selector "button.btn.btn-primary.btn-lg", text: "Large"
    end

    test "renders dropdown with direction" do
      render_inline(build(variant: "primary", direction: "up")) do |dropdown|
        dropdown.with_button("Up")
      end

      assert_selector "div.dropdown.dropdown-primary.dropdown-up"
    end

    test "renders dropdown with align" do
      render_inline(build(variant: "primary", align: "right")) do |dropdown|
        dropdown.with_button("Aligned")
      end

      assert_selector "div.dropdown.dropdown-primary.dropdown-right"
    end

    test "renders disabled dropdown" do
      render_inline(build(variant: "primary", disabled: true)) do |dropdown|
        dropdown.with_button("Disabled")
      end

      assert_selector "button.btn.btn-primary[disabled]", text: "Disabled"
    end

    test "renders dropdown with custom CSS class" do
      render_inline(build(variant: "primary", class: "custom-class")) do |dropdown|
        dropdown.with_button("Custom")
      end

      assert_selector "div.dropdown.dropdown-primary.custom-class"
    end

    test "renders dropdown items with icons" do
      render_inline(build(variant: "primary")) do |dropdown|
        dropdown.with_menu do |menu|
          menu.with_item("Item 1", "/path1", icon: "user")
        end
      end

      assert_selector "a.dropdown-menu-item svg"
    end

    test "renders dropdown with menu header" do
      render_inline(build(variant: "primary")) do |dropdown|
        dropdown.with_button("Dropdown")

        dropdown.with_menu do |menu|
          menu.with_header("Section 1")
          menu.with_item("Item 1", "/path1")
        end
      end

      assert_selector "div.dropdown-header", text: "Section 1"
      assert_selector "a.dropdown-menu-item", text: "Item 1"
    end

    test "renders dropdown with menu divider" do
      render_inline(build(variant: "primary")) do |dropdown|
        dropdown.with_button("Dropdown")

        dropdown.with_menu do |menu|
          menu.with_item("Item 1", "/path1")
          menu.with_divider
          menu.with_item("Item 2", "/path2")
        end
      end

      assert_selector "hr.dropdown-divider"
    end

    test "renders dropdown without caret" do
      render_inline(build(variant: "primary", skip_caret: true)) do |dropdown|
        dropdown.with_button("No Caret")
      end

      assert_selector "button.btn.btn-primary", text: "No Caret"
      assert_no_selector "svg.dropdown-arrow"
    end
  end
end
