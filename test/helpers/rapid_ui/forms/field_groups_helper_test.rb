require_relative "../helper_test_case"

module RapidUI
  module Forms
    class FieldGroupsHelperTest < HelperTestCase
      include RapidUI::Forms::FieldGroupsHelper

      test "new_form_field_groups returns a Forms::Groups component" do
        groups = new_form_field_groups("test_form")
        assert_instance_of Forms::Groups, groups
      end

      test "new_form_field_groups accepts id as argument" do
        groups = new_form_field_groups("my_form")
        assert_equal "my_form", groups.id
      end

      test "new_form_field_groups accepts horizontal option" do
        groups = new_form_field_groups("form", horizontal: true)
        assert groups.horizontal?
      end

      test "new_form_field_groups accepts gap option" do
        groups = new_form_field_groups("form", gap: 5)
        assert_equal 5, groups.gap
      end

      test "new_form_field_groups accepts colspans option" do
        colspans = { group: 12, label: 3, content: 9 }
        groups = new_form_field_groups("form", colspans: colspans)
        assert_equal colspans, groups.colspans
      end

      test "new_form_field_groups accepts block for configuration" do
        groups = new_form_field_groups("form") do |f|
          f.with_group :email do |g|
            g.text_field
          end
        end

        html = render(groups)
        assert_match(/email/, html)
      end

      test "form_field_groups helper renders form with multiple groups" do
        html = form_field_groups("multi_form") do |f|
          f.with_group :email do |g|
            g.email_field
          end
          f.with_group :password do |g|
            g.password_field
          end
        end

        render_inline(html)
        assert_selector "input[type='email'][name='email']"
        assert_selector "input[type='password'][name='password']"
      end

      test "form_field_groups helper renders form with radio button group" do
        html = form_field_groups("radio_form") do |f|
          f.with_radio_button_group :choice do |g|
            safe_join([
              g.radio_button("yes", checked: true, label: "Yes"),
              g.radio_button("no", label: "No"),
            ])
          end
        end

        render_inline(html)
        assert_selector "input[type='radio'][name='choice'][value='yes']"
        assert_selector "input[type='radio'][name='choice'][value='no']"
      end

      test "form_field_groups helper renders form with checkbox group" do
        html = form_field_groups("checkbox_form") do |f|
          f.with_checkbox_group :terms do |g|
            g.checkbox
          end
        end

        render_inline(html)
        assert_selector "input[type='checkbox'][name='terms']"
      end

      test "form_field_groups helper renders form with buttons" do
        html = form_field_groups("button_form") do |f|
          f.with_buttons do |g|
            g.with_submit_button("Submit")
            g.with_cancel_link("/cancel")
          end
        end

        render_inline(html)
        assert_selector "button[type='submit']", text: "Submit"
        assert_selector "a[href='/cancel']", text: "Cancel"
      end

      test "form_field_groups helper with custom gap" do
        html = form_field_groups("gapped_form", gap: 8) do |f|
          f.with_group :name do |g|
            g.text_field
          end
        end

        render_inline(html)
        assert_selector "div#gapped_form.gap-8"
      end
    end
  end
end
