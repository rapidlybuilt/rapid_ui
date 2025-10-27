require_relative "../helper_test_case"

module RapidUI
  module Controls
    class ButtonsHelperTest < HelperTestCase
      include RapidUI::Controls::ButtonsHelper

      test "new_button returns a Button component" do
        button = new_button
        assert_instance_of Button, button
      end

      test "new_button accepts content as arguments" do
        button = new_button("Test Content")
        html = render(button)
        assert_match(/Test Content/, html)
      end

      test "new_button accepts block for configuration" do
        button = new_button do |b|
          b.variant = "primary"
          b.size = "lg"
        end

        assert_equal "primary", button.variant
        assert_equal "lg", button.size
      end

      test "button helper with content as arguments" do
        render_inline button("Test Button", variant: "primary")
        assert_selector "button.btn.btn-primary", text: "Test Button"
      end

      test "button helper with content as block" do
        render_inline button(variant: "primary") { "Test Button" }
        assert_selector "button.btn.btn-primary", text: "Test Button"
      end

      test "dynamically generated methods for variants" do
        button = new_primary_button
        assert_equal "primary", button.variant

        render_inline primary_button("Test Button")
        assert_selector "button.btn.btn-primary", text: "Test Button"
      end
    end
  end
end
