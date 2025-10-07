require "test_helper"

class LayoutSystemTest < ActionDispatch::SystemTestCase
  driven_by :cuprite

  test "rendering layout template" do
    visit "/layout"

    assert_selector ".header", text: "Rapid"
    assert_selector "main.content p", text: "Layout body"
  end
end
