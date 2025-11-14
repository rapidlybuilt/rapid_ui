require "test_helper"

class SidebarTest < ActionDispatch::SystemTestCase
  driven_by :cuprite_desktop

  setup do
    visit components_root_path
  end

  test "sidebar is open by default on desktop" do
    assert_selector ".sidebar.open-lg"
  end

  test "sidebar is closed when the toggle button is clicked and it persists between visits" do
    click_on "Toggle navigation"
    assert_no_selector "#main_sidebar.open"

    visit components_root_path
    assert_no_selector "#main_sidebar.open"
  end

  test "active links" do
    assert_selector ".sidebar-link.active", text: "Index"
    assert_no_selector ".sidebar-link.active", text: "Typography"

    visit components_content_typography_path
    assert_no_selector ".sidebar-link.active", text: "Index"
    assert_selector ".sidebar-link.active", text: "Typography"
  end

  test "expanding the current section" do
    assert_selector ".sidebar-section.collapsed a", text: "Controls"

    visit components_controls_buttons_path
    assert_no_selector ".sidebar-section.collapsed a", text: "Controls"
  end
end
