require_relative "../view_component_test_case"

module RapidUI
  module Forms
    class LabelTest < ViewComponentTestCase
      described_class Label

      test "renders a basic label" do
        render_inline(build("Email", field_id: "email_field")) do
          "Email Address"
        end

        assert_selector "label.field-label[for='email_field']", text: "Email Address"
      end

      test "renders label with text parameter" do
        render_inline(build("Username", field_id: "username_field"))

        assert_selector "label.field-label[for='username_field']", text: "Username"
      end

      test "renders label with check style" do
        render_inline(build("Accept Terms", field_id: "terms_field", check: true))

        assert_selector "label.field-check-label[for='terms_field']", text: "Accept Terms"
      end

      test "renders label with horizontal layout and colspan" do
        render_inline(build("Full Name", field_id: "name_field", horizontal: true, colspan: 3))

        assert_selector "label.col-field-label.col-span-12.md\\:col-span-3[for='name_field']", text: "Full Name"
      end

      test "renders label with horizontal layout and default colspan" do
        render_inline(build("Description", field_id: "desc_field", horizontal: true, colspan: 12))

        assert_selector "label.col-field-label.col-span-12[for='desc_field']", text: "Description"
      end

      test "renders label with check and horizontal combined" do
        render_inline(build("Subscribe", field_id: "subscribe_field", check: true, horizontal: true, colspan: 4))

        assert_selector "label.field-check-label[for='subscribe_field']", text: "Subscribe"
      end

      test "renders label with custom CSS class" do
        render_inline(build("Custom Field", field_id: "custom_field", class: "my-custom-label"))

        assert_selector "label.field-label.my-custom-label[for='custom_field']", text: "Custom Field"
      end
    end
  end
end

