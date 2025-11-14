require "test_helper"

class ComponentsControlsTest < ActionDispatch::SystemTestCase
  driven_by :cuprite_desktop

  test "renders the buttons demo" do
    visit components_controls_buttons_path
    assert_text "Buttons"
  end

  test "renders the dropdowns demo" do
    visit components_controls_dropdowns_path
    assert_text "Dropdowns"
  end
end
