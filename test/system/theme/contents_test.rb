require "test_helper"

class ThemeContentsTest < ActionDispatch::SystemTestCase
  driven_by :cuprite

  test "renders the badges demo" do
    visit components_content_badges_path
    assert_text "Badges"
  end
end
