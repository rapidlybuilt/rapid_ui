require "test_helper"

class ComponentsContentsTest < ActionDispatch::SystemTestCase
  driven_by :cuprite

  test "renders the badges demo" do
    visit components_content_badges_path
    assert_text "Badges"
  end

  test "renders the tables demo" do
    visit components_content_tables_path
    assert_text "Tables"
  end

  test "renders the typography demo" do
    visit components_content_typography_path
    assert_text "Typography"
  end

  test "renders the icons demo" do
    visit components_content_icons_path
    assert_text "Icons"
  end
end
