require "test_helper"

class ComponentsFormsTest < ActionDispatch::SystemTestCase
  driven_by :cuprite

  test "renders the groups demo" do
    visit components_forms_groups_path
    assert_text "Form Groups"
  end
end
