require "test_helper"

class ThemeControlsTest < ActionDispatch::SystemTestCase
  driven_by :cuprite

  test "renders the buttons demo" do
    visit buttons_theme_controls_path
    assert_text "Buttons"
  end

  test "renders the dropdowns demo" do
    visit dropdowns_theme_controls_path
    assert_text "Dropdowns"
  end
end
