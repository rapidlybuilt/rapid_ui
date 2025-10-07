require "test_helper"

class LayoutSystemTest < ActionDispatch::SystemTestCase
  driven_by :cuprite

  test "rendering layout template" do
    visit "/layout"

    assert_selector "h1", text: "RapidUI Layout"
    assert_selector ".rapid-ui-content"
    assert_selector "p", text: "Layout body"
  end
end
