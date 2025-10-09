require "test_helper"

class LayoutDemoSidebarTest < ActionDispatch::SystemTestCase
  driven_by :cuprite

  setup do
    visit "/layout_demo"
  end

  test "sidebar is open by default" do
    assert_selector ".sidebar.open"
  end

  test "sidebar is closed when the toggle button is clicked and it persists between visits" do
    click_on "Toggle sidebar"
    assert_no_selector ".sidebar.open"

    visit "/layout_demo"
    assert_no_selector ".sidebar.open"
  end
end
