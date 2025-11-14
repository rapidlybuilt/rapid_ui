require "test_helper"

class StimulusTest < ActionDispatch::SystemTestCase
  driven_by :cuprite_desktop

  test "renders the expandable demo" do
    visit expandable_stimulus_path
    assert_text "Expandable"
  end
end
