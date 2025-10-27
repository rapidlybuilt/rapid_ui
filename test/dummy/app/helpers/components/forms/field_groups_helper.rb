module Components::Forms::FieldGroupsHelper
  def component_forms_groups_grid_field_groups
    demo_components do |c|
      c << new_field_groups("basic") do |f|
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
          g.with_option "personal", true, "Personal Account"
          g.with_option "business", false, "Business Account"
          g.with_option "nonprofit", false, "Non-Profit Organization", disabled: true
        end
        f.with_group :subscribe_to_newsletter, check: true do |g|
          g.with_label("Subscribe to newsletter")
          g.checkbox_tag
        end
        f.with_buttons do |g|
          g.with_submit_button "Register"
          g.with_cancel_button "/"
        end
      end
    end
  end

  def component_forms_groups_horizontal_field_groups
    demo_components do |c|
      c << new_field_groups("horizontal_demo", horizontal: true) do |f|
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
          g.with_option "regular", true, "Regular User"
          g.with_option "admin", false, "Admin User"
          g.with_option "superadmin", false, "Super Admin User"
        end
        f.with_group :confirmed, check: true do |g|
          g.with_label("Confirmed")
          g.checkbox_tag
        end
        f.with_buttons do |g|
          g.with_submit_button "Update"
          g.with_cancel_button "Back", "/"
        end
      end
    end
  end
end
