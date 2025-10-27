require_relative "view_component_test_case"

module RapidUI
  class ButtonTest < ViewComponentTestCase
    described_class Button

    test "renders a basic button" do
      render_inline(build) do
        "Basic Button"
      end

      assert_selector "button", text: "Basic Button"
    end

    test "renders button with variant" do
      render_inline(build(variant: "primary")) do
        "Primary Button"
      end

      assert_selector "button.btn.btn-primary", text: "Primary Button"
    end

    test "renders button with size" do
      render_inline(build(variant: "primary", size: "lg")) do
        "Large Button"
      end

      assert_selector "button.btn.btn-primary.btn-lg", text: "Large Button"
    end

    test "renders button as link when path is provided" do
      render_inline(build(variant: "primary", path: "/test")) do
        "Link Button"
      end

      assert_selector "a.btn.btn-primary[href='/test']", text: "Link Button"
    end

    test "renders disabled button" do
      render_inline(build(variant: "primary", disabled: true)) do
        "Disabled Button"
      end

      assert_selector "button.btn.btn-primary[disabled]", text: "Disabled Button"
    end

    test "renders button with title attribute" do
      render_inline(build(variant: "primary", title: "Click me")) do
        "Button"
      end

      assert_selector "button.btn.btn-primary[title='Click me']", text: "Button"
    end

    test "renders button with custom CSS class" do
      render_inline(build(variant: "primary", class: "custom-class")) do
        "Custom"
      end

      assert_selector "button.btn.btn-primary.custom-class", text: "Custom"
    end

    test "renders button with variant and size" do
      render_inline(build(variant: "success", size: "sm")) do
        "Small Success"
      end

      assert_selector "button.btn.btn-success.btn-sm", text: "Small Success"
    end
  end
end
