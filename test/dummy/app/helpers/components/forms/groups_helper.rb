module Components::Forms::GroupsHelper
  def component_forms_groups_basic_form
    demo_components do |c|
      c << new_form_groups(class: "gap-3") do |f|
        f.build_email_field_group(:email, col: 6)
        f.build_password_field_group(:password, col: 6)
        f.build_text_field_group(:address, placeholder: "1234 Main St", col: 12)
        f.build_text_field_group(:address_2, label_text: "Address 2", placeholder: "Apartment, studio, or floor", col: 12)
        f.build_text_field_group(:city, col: 6)
        f.build_select_field_group(:state, [ "Choose...", "Option 1", "Option 2" ], selected: "Choose...", col: 4)
        f.build_text_field_group(:zip, col: 2)
        f.build_checkbox_field_group(:terms_of_service, label_text: "Check me out", col: 12)
        f.build_submit_group("Sign in", size: 12)
      end
    end
  end

  def component_forms_groups_simple_form
    demo_components do |c|
      c << new_form_groups(class: "gap-3") do |f|
        f.build_text_field_group(:first_name, label_text: "First Name", col: 6)
        f.build_text_field_group(:last_name, label_text: "Last Name", col: 6)
        f.build_email_field_group(:email, label_text: "Email Address", placeholder: "you@example.com", col: 12)
        f.build_submit_group("Submit", variant: "success", size: 12)
      end
    end
  end

  def component_forms_groups_single_column_form
    demo_components do |c|
      c << new_form_groups(class: "gap-3") do |f|
        f.build_text_field_group(:username, col: 12)
        f.build_email_field_group(:user_email, label_text: "Email", col: 12)
        f.build_password_field_group(:user_password, label_text: "Password", col: 12)
        f.build_checkbox_field_group(:remember_me, label_text: "Remember me", col: 12)
        f.build_submit_group("Create Account", size: 12)
      end
    end
  end

  def component_forms_groups_custom_gap_sizes
    demo_components do |c|
      c << new_form_groups(class: "gap-1") do |f|
        f.build_text_field_group(:small_gap_1, label_text: "Small Gap (gap-1)", col: 6)
        f.build_text_field_group(:small_gap_2, label_text: "Field 2", col: 6)
      end

      c << tag.br

      c << new_form_groups(class: "gap-12") do |f|
        f.build_text_field_group(:large_gap_1, label_text: "Large Gap (gap-12)", col: 6)
        f.build_text_field_group(:large_gap_2, label_text: "Field 2", col: 6)
      end
    end
  end
end
