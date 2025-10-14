require "test_helper"

class ThemeContentsTest < ActionDispatch::SystemTestCase
  driven_by :cuprite

  test "renders the badges demo" do
    visit badges_theme_content_path
    assert_text "Badges"
  end

  test "renders the expandable demo" do
    visit expandable_theme_content_path
    assert_text "Expandable"
  end
end
