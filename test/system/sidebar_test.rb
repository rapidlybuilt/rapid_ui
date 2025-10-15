require "test_helper"

class SidebarTest < ActionDispatch::SystemTestCase
  driven_by :cuprite

  setup do
    visit "/"
  end

  test "sidebar is open by default" do
    assert_selector ".sidebar.open"
  end

  test "sidebar is closed when the toggle button is clicked and it persists between visits" do
    click_on "Toggle sidebar"
    assert_no_selector ".sidebar.open"

    visit "/"
    assert_no_selector ".sidebar.open"
  end

  test "active links" do
    assert_selector ".sidebar-link.active", text: "Dashboard"
    assert_no_selector ".sidebar-link.active", text: "Typography"

    visit components_content_typography_path
    assert_no_selector ".sidebar-link.active", text: "Dashboard"
    assert_selector ".sidebar-link.active", text: "Typography"
  end

  test "expanding the current section" do
    assert_selector ".sidebar-section.collapsed button", text: "Controls"

    visit components_controls_buttons_path
    assert_no_selector ".sidebar-section.collapsed button", text: "Controls"
  end
end
