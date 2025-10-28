module Components::Forms::FieldGroupsHelper
  def component_forms_groups_grid_field_groups
    demo_components do |c|
      c << new_form_field_groups("basic") do |f|
        f.with_group(:email, colspan: 6) do |g|
          g.email_field_tag
        end
        f.with_group(:password, colspan: 6) do |g|
          g.password_field_tag
        end
        f.with_group(:address) do |g|
          g.text_field_tag placeholder: "1234 Main St"
        end
        f.with_group(:address_2) do |g|
          g.text_field_tag placeholder: "Apartment, studio, or floor"
        end
        f.with_group(:city, colspan: 6) do |g|
          g.text_field_tag "Atlanta"
        end
        f.with_group(:state, colspan: 4) do |g|
          g.with_label("State/Province")
          g.select_tag options_for_select([ "", "California", "Georgia" ], selected: "")
        end
        f.with_group(:zip, colspan: 2) do |g|
          g.text_field_tag
        end
        f.with_radio_button_group :account_type do |g|
          safe_join([
            g.radio_button_tag("personal", true, label: "Personal Account"),
            g.radio_button_tag("business", false, label: "Business Account"),
            g.radio_button_tag("nonprofit", false, label: "Non-Profit Organization", disabled: true),
          ])
        end
        f.with_checkbox_group :subscribe_to_newsletter do |g|
          g.checkbox_tag
        end
        f.with_buttons do |g|
          g.with_submit_button "Register"
          g.with_cancel_link "/"
        end
      end
    end
  end

  def component_forms_groups_horizontal_field_groups
    demo_components do |c|
      c << new_form_field_groups("horizontal_demo", horizontal: true) do |f|
        f.with_group(:email) do |g|
          g.text_field_tag
        end
        f.with_group(:first_name, colspan: 4) do |g|
          g.text_field_tag
        end
        f.with_group(:last_name, colspan: 4) do |g|
          g.text_field_tag
        end
        f.with_radio_button_group :user_type do |g|
          safe_join([
            g.radio_button_tag("regular", true, label: "Regular User"),
            g.radio_button_tag("admin", false, label: "Admin User"),
            g.radio_button_tag("superadmin", false, label: "Super Admin User", disabled: true),
          ])
        end
        f.with_checkbox_group :confirmed do |g|
          g.checkbox_tag
        end
        f.with_buttons do |g|
          g.with_submit_button "Update"
          g.with_cancel_link "Back", "/"
        end
      end
    end
  end

  def component_forms_field_groups_errors
    demo_components do |c|
      c << new_form_field_groups("validation_demo") do |f|
        f.with_group(:email, colspan: 6, error: "Email is required") do |g|
          g.email_field_tag
        end
        f.with_group(:password, colspan: 6, error: "Password must be at least 8 characters") do |g|
          g.password_field_tag
        end
      end

      c << new_form_field_groups("horizontal_validation_demo", horizontal: true, class: "mt-8") do |f|
        f.with_group(:email) do |g|
          g.with_error { "Please enter a valid email address. #{link_to 'Learn more', '#', class: "underline"}".html_safe }
          g.email_field_tag
        end
      end
    end
  end

  def component_forms_field_groups_hints
    demo_components do |c|
      c << new_form_field_groups("hint_demo") do |f|
        f.with_group(:username, colspan: 6, hint: "Must be at least 3 characters") do |g|
          g.text_field_tag
        end
        f.with_group(:email, colspan: 6, hint: "We'll never share your email with anyone else") do |g|
          g.email_field_tag
        end
        f.with_group(:password, hint: "Use a mix of letters, numbers, and symbols", error: "Password is required") do |g|
          g.password_field_tag
        end
      end

      c << new_form_field_groups("horizontal_hint_demo", horizontal: true, class: "mt-8") do |f|
        f.with_group(:bio) do |g|
          g.with_hint { "Tell us about yourself in <strong>200 characters</strong> or less".html_safe }
          g.textarea_tag
        end
      end
    end
  end
end
