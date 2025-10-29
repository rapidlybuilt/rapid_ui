require_relative "view_component_test_case"

module RapidUI
  class ToggleButtonTest < ViewComponentTestCase
    described_class ToggleButton

    test "renders a basic toggle button" do
      render_inline build do
        "Toggle Button"
      end

      assert_selector "button[data-controller='toggle-button']", text: "Toggle Button"
      assert_selector "button[data-action='click->toggle-button#toggle']"
    end

    test "renders toggle button in on state" do
      render_inline build(on: true) do
        "On"
      end

      assert_selector "button.on", text: "On"
    end

    test "renders toggle button in off state" do
      render_inline build(off: true) do
        "Off"
      end

      refute_selector "button.on"
    end

    test "renders toggle button with custom on_class" do
      render_inline build(on: true, on_class: "active") do
        "Active"
      end

      assert_selector "button.active", text: "Active"
      assert_selector "button[data-toggle-button-on-class='active']"
    end

    test "renders toggle button with custom off_class" do
      render_inline build(off: true, off_class: "inactive") do
        "Inactive"
      end

      assert_selector "button.inactive", text: "Inactive"
      assert_selector "button[data-toggle-button-off-class='inactive']"
    end

    test "renders toggle button with target" do
      target = Struct.new(:id).new("sidebar-1")

      render_inline build(target: target) do
        "Toggle Sidebar"
      end

      assert_selector "button[data-toggle-button-target-value='sidebar-1']", text: "Toggle Sidebar"
    end

    test "renders toggle button with variant from Button" do
      render_inline build(on: true, variant: "primary") do
        "Primary Toggle"
      end

      assert_selector "button.btn.btn-primary.on", text: "Primary Toggle"
    end

    test "renders toggle button with custom CSS class" do
      render_inline build(on: true, class: "custom-class") do
        "Custom"
      end

      assert_selector "button.on.custom-class", text: "Custom"
    end

    test "renders toggle button with both on_class and off_class" do
      render_inline build(on: true, on_class: "active", off_class: "inactive") do
        "Toggle"
      end

      assert_selector "button.active", text: "Toggle"
      assert_selector "button[data-toggle-button-on-class='active']"
      assert_selector "button[data-toggle-button-off-class='inactive']"
    end

    test "toggling off" do
      button = build(on: true)
      assert_equal true, button.on?
      assert_equal false, button.off?

      button.off = true
      assert_equal false, button.on?
      assert_equal true, button.off?
    end
  end
end
