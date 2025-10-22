module Components::Forms::GroupsHelper
  def component_forms_groups_basic_form
    demo_components do |c|
      c << new_field_groups("basic") do |f|
        f.build_group(:email, col: 6) do |g|
          g.email_field_tag
        end
        f.build_group(:password, col: 6) do |g|
          g.password_field_tag
        end
        f.build_group(:address, col: 12) do |g|
          g.text_field_tag placeholder: "1234 Main St"
        end
        f.build_group(:address_2, col: 12) do |g|
          g.build_label("Address 2")
          g.text_field_tag placeholder: "Apartment, studio, or floor"
        end
        f.build_group(:city, col: 6) do |g|
          g.text_field_tag "Atlanta"
        end
        f.build_group(:state, col: 4) do |g|
          g.select_tag options_for_select([ "Choose...", "Option 1", "Option 2" ], selected: "Choose...")
        end
        f.build_group(:zip, col: 2) do |g|
          g.text_field_tag
        end
        f.build_group(:terms_of_service, check: true, col: 12) do |g|
          g.build_label("Check me out")
          g.checkbox_tag
        end
        f.build_submit_group("Sign in", col: 12)
      end
    end
  end

  def component_forms_groups_gap_sizes_form
    demo_components do |c|
      c << new_field_groups("gap_sizes_1", gap: 1) do |f|
        f.build_group(:small_gap_1, col: 6) do |g|
          g.with_label("Small Gap (gap-1)")
          g.text_field_tag
        end
        f.build_group(:small_gap_2, col: 6) do |g|
          g.with_label("Field 2")
          g.text_field_tag
        end
      end

      c << tag.br

      c << new_field_groups("gap_sizes_2", gap: 12) do |f|
        f.build_group(:large_gap_1, col: 6) do |g|
          g.with_label("Large Gap (gap-12)")
          g.text_field_tag
        end
        f.build_group(:large_gap_2, col: 6) do |g|
          g.with_label("Field 2")
          g.text_field_tag
        end
      end
    end
  end
end
