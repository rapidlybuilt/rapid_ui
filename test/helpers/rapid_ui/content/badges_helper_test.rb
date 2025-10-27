require_relative "../helper_test_case"

module RapidUI
  module Content
    class BadgesHelperTest < HelperTestCase
      include RapidUI::Content::BadgesHelper

      test "new_badge returns a Badge component" do
        badge = new_badge
        assert_instance_of Badge, badge
      end

      test "new_badge accepts variant option" do
        badge = new_badge(variant: "success")
        assert_equal "success", badge.variant
      end

      test "new_badge accepts pill option" do
        badge = new_badge(pill: true)
        assert badge.pill?
      end

      test "new_badge accepts content as arguments" do
        badge = new_badge("Test Content")
        html = render(badge)
        assert_match(/Test Content/, html)
      end

      test "new_badge accepts block for configuration" do
        badge = new_badge do |b|
          b.variant = "danger"
          b.pill = true
        end

        assert_equal "danger", badge.variant
        assert badge.pill?
      end

      test "badge helper with content as arguments" do
        render_inline badge("Test Badge")
        assert_selector "span.badge.badge-dark-primary", text: "Test Badge"
      end

      test "badge helper with content as block" do
        render_inline badge { "Test Badge" }
        assert_selector "span.badge.badge-dark-primary", text: "Test Badge"
      end

      test "dynamically generated methods" do
        variant = "success"

        badge = new_success_badge
        assert_equal variant, badge.variant
        assert_not badge.pill?

        badge = new_success_pill_badge
        assert_equal variant, badge.variant
        assert badge.pill?

        render_inline success_badge("Test Badge")
        assert_selector "span.badge.badge-#{variant}", text: "Test Badge"

        render_inline success_pill_badge("Test Badge")
        assert_selector "span.badge.badge-#{variant}.badge-pill", text: "Test Badge"
      end
    end
  end
end
