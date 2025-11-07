require_relative "view_component_test_case"

module RapidUI
  class AlertTest < ViewComponentTestCase
    described_class Alert

    test "renders a basic alert" do
      render_inline build do
        "Basic Alert"
      end

      assert_selector "div.alert.alert-info", text: "Basic Alert"
    end

    test "renders alert with custom variant" do
      render_inline build(variant: "success") do
        "Success Alert"
      end

      assert_selector "div.alert.alert-success", text: "Success Alert"
    end

    test "renders alert with danger variant" do
      render_inline build(variant: "danger") do
        "Danger Alert"
      end

      assert_selector "div.alert.alert-danger", text: "Danger Alert"
    end

    test "renders alert with warning variant" do
      render_inline build(variant: "warning") do
        "Warning Alert"
      end

      assert_selector "div.alert.alert-warning", text: "Warning Alert"
    end

    test "renders dismissible alert" do
      render_inline build(dismissible: true) do
        "Dismissible Alert"
      end

      assert_selector "div.alert.alert-info[data-controller='dismissible']", text: "Dismissible Alert"
      assert_selector "button.alert-close svg"
    end

    test "renders dismissible alert with explicit body content" do
      render_inline build("Dismissible Alert", dismissible: true)

      assert_selector "div.alert.alert-info[data-controller='dismissible']", text: "Dismissible Alert"
      assert_selector "button.alert-close svg"
    end

    test "renders dismissible alert with explicit close button" do
      render_inline build(dismissible: true) do |a|
        a.with_close_button "Dismiss"
        "Dismissible Alert"
      end

      assert_selector "div.alert.alert-info[data-controller='dismissible']", text: "Dismissible Alert"
      assert_selector "button.alert-close", text: "Dismiss"
    end

    test "renders alert with icon" do
      render_inline build(icon: "info") do
        "Alert with Icon"
      end

      assert_selector "div.alert.alert-info", text: "Alert with Icon"
      assert_selector "div.alert-icon"
    end

    test "renders alert with variant and dismissible" do
      render_inline build(variant: "success", dismissible: true) do
        "Dismissible Success"
      end

      assert_selector "div.alert.alert-success[data-controller='dismissible']", text: "Dismissible Success"
      assert_selector "button.alert-close svg"
    end

    test "renders alert with custom CSS class" do
      render_inline build(class: "custom-class") do
        "Custom"
      end

      assert_selector "div.alert.alert-info.custom-class", text: "Custom"
    end

    test "renders alert with icon and dismissible" do
      render_inline build(icon: "info", dismissible: true) do
        "Alert with Icon and Close"
      end

      assert_selector "div.alert.alert-info[data-controller='dismissible']", text: "Alert with Icon and Close"
      assert_selector "div.alert-icon"
      assert_selector "button.alert-close"
    end
  end
end
