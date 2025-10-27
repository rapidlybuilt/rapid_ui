require_relative "../helper_test_case"

module RapidUI
  module Feedback
    class AlertsHelperTest < HelperTestCase
      include RapidUI::Feedback::AlertsHelper

      test "new_alert returns an Alert component" do
        alert = new_alert
        assert_instance_of Alert, alert
      end

      test "new_alert accepts variant option" do
        alert = new_alert(variant: "success")
        assert_equal "success", alert.variant
      end

      test "new_alert accepts dismissible option" do
        alert = new_alert(dismissible: true)
        assert alert.dismissible?
      end

      test "new_alert accepts icon option" do
        alert = new_alert(icon: "info")
        html = render(alert)
        assert_match(/alert-icon/, html)
      end

      test "new_alert accepts content as arguments" do
        alert = new_alert("Test Content")
        html = render(alert)
        assert_match(/Test Content/, html)
      end

      test "new_alert accepts block for configuration" do
        alert = new_alert do |a|
          a.variant = "danger"
          a.dismissible = true
        end

        assert_equal "danger", alert.variant
        assert alert.dismissible?
      end

      test "alert helper with content as arguments" do
        render_inline alert("Test Alert")
        assert_selector "div.alert.alert-info", text: "Test Alert"
      end

      test "alert helper with content as block" do
        render_inline alert { "Test Alert" }
        assert_selector "div.alert.alert-info", text: "Test Alert"
      end

      test "dynamically generated methods" do
        variant = "success"

        alert = new_success_alert
        assert_equal variant, alert.variant

        render_inline success_alert("Test Alert")
        assert_selector "div.alert.alert-#{variant}", text: "Test Alert"
      end

      test "dynamically generated methods for variants" do
        alert = new_danger_alert
        assert_equal "danger", alert.variant

        render_inline danger_alert("Danger Alert")
        assert_selector "div.alert.alert-danger", text: "Danger Alert"
      end
    end
  end
end
