require "test_helper"

class ApplicationLayoutTest < ActionDispatch::SystemTestCase
  driven_by :cuprite

  setup do
    TestController.test_layout = layout
  end

  teardown do
    TestController.test_layout = nil
  end

  test "empty layout" do
    visit "/test"
    assert_text "Main test content"
  end

  def layout
    @layout ||= RapidUI::ApplicationLayout.new(factory: RapidUI::Factory.new)
  end
end
