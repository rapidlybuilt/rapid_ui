require_relative "../view_component_test_case"

module RapidUI
  module Forms
    class FieldGroupTest < ViewComponentTestCase
      described_class FieldGroup

      test "renders a basic text field group" do
        render_inline build("username", id: "username_group", field_id: "username_field", colspans: { group: 12 }) do |g|
          g.text_field_tag
        end

        assert_selector "div.col-span-12"
        assert_selector "label.field-label[for='username_field']", text: "Username"
        assert_selector "input[type='text'][name='username'][id='username_field'].field-control"
      end

      test "renders email field with custom colspan" do
        render_inline build("email", id: "email_group", field_id: "email_field", colspans: { group: 6 }) do |g|
          g.email_field_tag
        end

        assert_selector "div.col-span-12.md\\:col-span-6"
        assert_selector "label.field-label[for='email_field']", text: "Email"
        assert_selector "input[type='email'][name='email'][id='email_field'].field-control"
      end

      test "renders password field" do
        render_inline build("password", id: "password_group", field_id: "password_field", colspans: { group: 12 }) do |g|
          g.password_field_tag
        end

        assert_selector "label.field-label[for='password_field']", text: "Password"
        assert_selector "input[type='password'][name='password'][id='password_field'].field-control"
      end

      test "renders textarea field" do
        render_inline build("description", id: "desc_group", field_id: "desc_field", colspans: { group: 12 }) do |g|
          g.textarea_tag
        end

        assert_selector "label.field-label[for='desc_field']", text: "Description"
        assert_selector "textarea[name='description'][id='desc_field'].field-control"
      end

      test "renders checkbox field" do
        render_inline build("subscribe", id: "subscribe_group", field_id: "subscribe_field", check: true, colspans: { group: 12 }) do |g|
          g.checkbox_tag
        end

        assert_selector "div.col-span-12"
        assert_selector "input[type='checkbox'][name='subscribe'][id='subscribe_field'].field-check-input"
        assert_selector "label.field-check-label[for='subscribe_field']", text: "Subscribe"
      end

      test "renders with custom label text" do
        render_inline build("email", id: "email_group", field_id: "email_field", colspans: { group: 12 }) do |g|
          g.email_field_tag
          g.with_label("Email Address")
        end

        assert_selector "label.field-label[for='email_field']", text: "Email Address"
      end

      test "renders horizontal text field" do
        render_inline build("name", id: "name_group", field_id: "name_field", horizontal: true, colspans: { group: 12, label: 3, content: 9 }) do |g|
          g.text_field_tag
        end

        assert_selector "div.col-span-12.grid.grid-cols-12"
        assert_selector "label.col-field-label.col-span-12.md\\:col-span-3[for='name_field']", text: "Name"
        assert_selector "div.col-span-12.md\\:col-span-9" do
          assert_selector "input[type='text'][name='name'][id='name_field'].field-control"
        end
      end

      test "renders horizontal checkbox with spacer" do
        render_inline build("terms", id: "terms_group", field_id: "terms_field", check: true, horizontal: true, colspans: { group: 12, label: 3, content: 9 }) do |g|
          g.checkbox_tag
        end

        assert_selector "div.col-span-12.grid.grid-cols-12"
        assert_selector "div.col-span-12.md\\:col-span-3"  # Empty spacer
        assert_selector "div.col-span-12.md\\:col-span-9" do
          assert_selector "input[type='checkbox'][name='terms'][id='terms_field'].field-check-input"
          assert_selector "label.field-check-label[for='terms_field']", text: "Terms"
        end
      end

      test "renders field with placeholder" do
        render_inline build("address", id: "address_group", field_id: "address_field", colspans: { group: 12 }) do |g|
          g.text_field_tag placeholder: "1234 Main St"
        end

        assert_selector "input[placeholder='1234 Main St']"
      end

      test "renders field with value" do
        render_inline build("city", id: "city_group", field_id: "city_field", colspans: { group: 12 }) do |g|
          g.text_field_tag "Atlanta"
        end

        assert_selector "input[value='Atlanta']"
      end

      test "renders select field" do
        render_inline build("state", id: "state_group", field_id: "state_field", colspans: { group: 12 }) do |g|
          g.select_tag "<option>California</option><option>Georgia</option>".html_safe
        end

        assert_selector "label.field-label[for='state_field']", text: "State"
        assert_selector "select[name='state'][id='state_field'].field-control" do
          assert_selector "option", text: "California"
          assert_selector "option", text: "Georgia"
        end
      end

      test "renders number field" do
        render_inline build("age", id: "age_group", field_id: "age_field", colspans: { group: 12 }) do |g|
          g.number_field_tag
        end

        assert_selector "label.field-label[for='age_field']", text: "Age"
        assert_selector "input[type='number'][name='age'][id='age_field'].field-control"
      end

      test "renders with custom CSS class" do
        render_inline build("custom", id: "custom_group", field_id: "custom_field", class: "my-field-group", colspans: { group: 12 }) do |g|
          g.text_field_tag
        end
        assert_selector "div.col-span-12.my-field-group"
      end

      test "renders field with custom CSS class on input" do
        render_inline build("styled", id: "styled_group", field_id: "styled_field", colspans: { group: 12 }) do |g|
          g.text_field_tag class: "custom-input"
        end
        assert_selector "input.field-control.custom-input"
      end

      test "renders with responsive colspan hash" do
        render_inline build("responsive", id: "responsive_group", field_id: "responsive_field", colspans: { group: { md: 6, sm: 8 } }) do |g|
          g.text_field_tag
        end

        assert_selector "div.col-span-12.md\\:col-span-6.sm\\:col-span-8"
      end

      test "renders horizontal form with responsive colspan hash" do
        render_inline build("responsive_horizontal", id: "responsive_group", field_id: "responsive_field", horizontal: true, colspans: { group: 12, label: { md: 3, lg: 2 }, content: { md: 9, lg: 10 } }) do |g|
          g.text_field_tag
        end

        assert_selector "label.col-field-label.col-span-12.md\\:col-span-3.lg\\:col-span-2"
        assert_selector "div.col-span-12.md\\:col-span-9.lg\\:col-span-10"
      end

      test "renders with string colspan for custom classes" do
        render_inline build("custom_classes", id: "custom_group", field_id: "custom_field", colspans: { group: "sm:col-span-6 lg:col-span-4" }) do |g|
          g.text_field_tag
        end

        assert_selector "div.col-span-12.sm\\:col-span-6.lg\\:col-span-4"
      end

      test "renders with error message" do
        render_inline build("email", id: "email_group", field_id: "email_field", error: "Email is required", colspans: { group: 12 }) do |g|
          g.email_field_tag
        end

        assert_selector "label.field-label.text-danger[for='email_field']", text: "Email"
        assert_selector "input[type='email'].field-control.text-danger"
        assert_selector "div.field-error.text-danger", text: "Email is required"
      end

      test "renders without error styling when no error" do
        render_inline build("email", id: "email_group", field_id: "email_field", colspans: { group: 12 }) do |g|
          g.email_field_tag
        end

        assert_selector "label.field-label[for='email_field']", text: "Email"
        assert_no_selector "label.text-danger"
        assert_no_selector "input.text-danger"
        assert_no_selector "div.field-error"
      end

      test "renders horizontal form with error message" do
        render_inline build("email", id: "email_group", field_id: "email_field", horizontal: true, error: "Invalid email", colspans: { group: 12, label: 3, content: 9 }) do |g|
          g.email_field_tag
        end

        assert_selector "label.col-field-label.text-danger[for='email_field']", text: "Email"
        assert_selector "input[type='email'].field-control.text-danger"
        assert_selector "div.field-error.text-danger", text: "Invalid email"
      end

      test "renders checkbox with error message" do
        render_inline build("terms", id: "terms_group", field_id: "terms_field", check: true, error: "You must accept the terms", colspans: { group: 12 }) do |g|
          g.checkbox_tag
        end

        assert_selector "input[type='checkbox'].field-check-input.text-danger"
        assert_selector "label.field-check-label.text-danger[for='terms_field']", text: "Terms"
        assert_selector "div.field-error.text-danger", text: "You must accept the terms"
      end

      test "renders textarea with error message" do
        render_inline build("bio", id: "bio_group", field_id: "bio_field", error: "Bio is too short", colspans: { group: 12 }) do |g|
          g.textarea_tag
        end

        assert_selector "label.field-label.text-danger[for='bio_field']", text: "Bio"
        assert_selector "textarea.field-control.text-danger"
        assert_selector "div.field-error.text-danger", text: "Bio is too short"
      end
    end
  end
end
