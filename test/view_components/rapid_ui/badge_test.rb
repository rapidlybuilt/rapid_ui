require_relative "view_component_test_case"

module RapidUI
  class BadgeTest < ViewComponentTestCase
    described_class Badge

    test "renders a basic badge" do
      render_inline(build) do
        "Basic Badge"
      end

      assert_selector "span.badge.badge-dark-primary", text: "Basic Badge"
    end

    test "renders badge with custom variant" do
      render_inline(build(variant: "success")) do
        "Success Badge"
      end

      assert_selector "span.badge.badge-success", text: "Success Badge"
    end

    test "renders badge with pill style" do
      render_inline(build(pill: true)) do
        "Pill Badge"
      end

      assert_selector "span.badge.badge-pill", text: "Pill Badge"
    end

    test "renders badge with both variant and pill" do
      render_inline(build(variant: "success", pill: true)) do
        "Success Pill"
      end

      assert_selector "span.badge.badge-success.badge-pill", text: "Success Pill"
    end

    test "renders badge with custom CSS class" do
      render_inline(build(class: "custom-class")) do
        "Custom"
      end

      assert_selector "span.badge.badge-dark-primary.custom-class", text: "Custom"
    end
  end
end
