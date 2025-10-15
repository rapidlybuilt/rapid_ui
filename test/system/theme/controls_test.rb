require "test_helper"

class ThemeControlsTest < ActionDispatch::SystemTestCase
  driven_by :cuprite

  test "renders the buttons demo" do
    visit components_controls_buttons_path
    assert_text "Buttons"
  end

  test "renders the dropdowns demo" do
    visit components_controls_dropdowns_path
    assert_text "Dropdowns"
  end
end
