require_relative "../view_component_test_case"

module RapidUI
  module Forms
    class GroupsTest < ViewComponentTestCase
      described_class Groups

      test "renders basic form with single field group" do
        render_inline build("basic_form") do |c|
          c.with_group :email do |g|
            g.text_field
          end
        end

        assert_selector "div.grid.grid-cols-12.gap-3"
        assert_selector "div.col-span-12" do
          assert_selector "label.field-label[for='basic_form_email']", text: "Email"
          assert_selector "input[type='text'][name='email'][id='basic_form_email']"
        end
      end

      test "renders form with multiple field groups" do
        render_inline build("registration_form") do |c|
          c.with_group :email, colspan: 6 do |g|
            g.email_field
          end
          c.with_group :password, colspan: 6 do |g|
            g.password_field
          end
        end

        assert_selector "div.col-span-12.md\\:col-span-6"
        assert_selector "div.col-span-12.md\\:col-span-6"
      end

      test "renders horizontal form layout" do
        render_inline build("horizontal_form", horizontal: true) do |c|
          c.with_group :username do |g|
            g.text_field
          end
        end

        assert_selector "div.grid.grid-cols-12.gap-3"
        assert_selector "div.col-span-12.grid.grid-cols-12" do
          assert_selector "label.col-field-label.col-span-12.md\\:col-span-2[for='horizontal_form_username']", text: "Username"
          assert_selector "div.col-span-12.md\\:col-span-10" do
            assert_selector "input[type='text'][name='username']"
          end
        end
      end

      test "renders with custom colspans" do
        render_inline build("custom_form", horizontal: true, colspans: { group: 12, label: 4, content: 8 }) do |c|
          c.with_group :name do |g|
            g.text_field
          end
        end

        assert_selector "label.col-field-label.col-span-12.md\\:col-span-4"
        assert_selector "div.col-span-12.md\\:col-span-8"
      end

      test "renders with custom gap" do
        render_inline build("gapped_form", gap: 6) do |c|
          c.with_group :email do |g|
            g.text_field
          end
        end

        assert_selector "div.grid.grid-cols-12.gap-6"
      end

      test "renders with radio button group" do
        render_inline build("radio_form") do |c|
          c.with_radio_button_group(:account_type) do |g|
            safe_join([
              g.radio_button("personal", checked: true, label: "Personal"),
              g.radio_button("business", label: "Business"),
            ])
          end
        end

        assert_selector "div#radio_form_account_type_group" do
          assert_selector "input[type='radio'][name='account_type'][value='personal'][checked]"
          assert_selector "input[type='radio'][name='account_type'][value='business']"
        end
      end

      test "renders with checkbox group" do
        render_inline build("checkbox_form") do |c|
          c.with_checkbox_group :subscribe do |g|
            g.checkbox
          end
        end

        assert_selector "div#checkbox_form_subscribe_group" do
          assert_selector "input[type='checkbox'][name='subscribe'].field-control-inline"
          assert_selector "label.field-label-inline[for='checkbox_form_subscribe']", text: "Subscribe"
        end
      end

      test "renders with buttons group" do
        render_inline build("button_form") do |c|
          c.with_buttons do |g|
            g.with_submit_button("Save")
            g.with_cancel_link("/")
          end
        end

        assert_selector "div.field-buttons" do
          assert_selector "button[type='submit'].btn.btn-primary", text: "Save"
          assert_selector "a.btn.btn-secondary[href='/']", text: "Cancel"
        end
      end

      test "renders complete form with mixed group types" do
        render_inline build("complete_form") do |c|
          c.with_group :email do |g|
            g.email_field
          end
          c.with_group :password do |g|
            g.password_field
          end
          c.with_radio_button_group :user_type do |g|
            g.radio_button("regular", checked: true, label: "Regular User")
            g.radio_button("admin", label: "Admin")
          end
          c.with_checkbox_group :terms do |g|
            g.checkbox
          end
          c.with_buttons do |g|
            g.with_submit_button("Register")
            g.with_cancel_link("/")
          end
        end

        assert_selector "div#complete_form_email_group"
        assert_selector "div#complete_form_password_group"
        assert_selector "div#complete_form_user_type_group"
        assert_selector "div#complete_form_terms_group"
        assert_selector "div.field-buttons"
      end

      test "renders horizontal form with buttons group" do
        render_inline build("horizontal_button_form", horizontal: true) do |c|
          c.with_group :name do |g|
            g.text_field
          end
          c.with_buttons do |g|
            g.with_submit_button("Update")
          end
        end

        assert_selector "div.col-span-12.grid.grid-cols-12", count: 2  # One for field group, one for buttons group
      end

      test "renders with custom CSS class" do
        render_inline build("styled_form", class: "custom-form-class") do |c|
          c.with_group :email do |g|
            g.text_field
          end
        end

        assert_selector "div.grid.grid-cols-12.custom-form-class"
      end

      test "renders field group with custom colspan in horizontal layout" do
        render_inline build("colspan_form", horizontal: true) do |c|
          c.with_group :short, colspan: 4 do |g|
            g.text_field
          end
          c.with_group :long, colspan: 8 do |g|
            g.text_field
          end
        end

        # In horizontal mode, colspan applies to content, not group
        assert_selector "div#colspan_form_short_group" do
          assert_selector "div.col-span-12.md\\:col-span-4"
        end
        assert_selector "div#colspan_form_long_group" do
          assert_selector "div.col-span-12.md\\:col-span-8"
        end
      end

      test "renders without gap when gap is nil" do
        render_inline build("no_gap_form", gap: nil) do |c|
          c.with_group :email do |g|
            g.text_field
          end
        end

        assert_selector "div.grid.grid-cols-12"
        assert_no_selector "div.gap-3"
      end
    end
  end
end
