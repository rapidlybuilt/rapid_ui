require "test_helper"

class ComponentsFeedbackTest < ActionDispatch::SystemTestCase
  driven_by :cuprite_desktop

  test "renders the alerts demo" do
    visit components_feedback_alerts_path
    assert_text "Alerts"
  end
end
