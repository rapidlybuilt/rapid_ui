module Components::Controls::DropdownsHelper
  def component_controls_dropdowns_variants
    demo_components do |c|
      c << new_primary_dropdown("Primary") do |dropdown|
        dropdown.menu.build_item("Action 1", "#")
        dropdown.menu.build_item("Action 2", "#")
      end

      c << new_secondary_dropdown("Secondary") do |dropdown|
        dropdown.menu.build_item("Action 1", "#")
        dropdown.menu.build_item("Action 2", "#")
      end

      c << new_naked_dropdown("Naked") do |dropdown|
        dropdown.menu.build_item("Action 1", "#")
        dropdown.menu.build_item("Action 2", "#")
      end

      c << new_success_dropdown("Success") do |dropdown|
        dropdown.menu.build_item("Action 1", "#")
        dropdown.menu.build_item("Action 2", "#")
      end

      c << new_warning_dropdown("Warning") do |dropdown|
        dropdown.menu.build_item("Action 1", "#")
        dropdown.menu.build_item("Action 2", "#")
      end

      c << new_danger_dropdown("Danger") do |dropdown|
        dropdown.menu.build_item("Action 1", "#")
        dropdown.menu.build_item("Action 2", "#")
      end
    end
  end

  def component_controls_dropdowns_outline_variants
    demo_components do |c|
      c << new_outline_primary_dropdown("Outline Primary") do |dropdown|
        dropdown.menu.build_item("Action 1", "#")
        dropdown.menu.build_item("Action 2", "#")
      end

      c << new_outline_success_dropdown("Outline Success") do |dropdown|
        dropdown.menu.build_item("Action 1", "#")
        dropdown.menu.build_item("Action 2", "#")
      end

      c << new_outline_warning_dropdown("Outline Warning") do |dropdown|
        dropdown.menu.build_item("Action 1", "#")
        dropdown.menu.build_item("Action 2", "#")
      end

      c << new_outline_danger_dropdown("Outline Danger") do |dropdown|
        dropdown.menu.build_item("Action 1", "#")
        dropdown.menu.build_item("Action 2", "#")
      end
    end
  end

  def component_controls_dropdowns_sizes
    demo_components do |c|
      c << new_primary_dropdown("Small", size: "sm") do |dropdown|
        dropdown.menu.build_item("Action 1", "#")
        dropdown.menu.build_item("Action 2", "#")
        dropdown.menu.build_item("Action 3", "#")
      end

      c << new_primary_dropdown("Medium (Default)") do |dropdown|
        dropdown.menu.build_item("Action 1", "#")
        dropdown.menu.build_item("Action 2", "#")
        dropdown.menu.build_item("Action 3", "#")
      end

      c << new_primary_dropdown("Large", size: "lg") do |dropdown|
        dropdown.menu.build_item("Action 1", "#")
        dropdown.menu.build_item("Action 2", "#")
        dropdown.menu.build_item("Action 3", "#")
      end
    end
  end

  def component_controls_dropdowns_disabled
    demo_components do |c|
      c << new_primary_dropdown("Primary Disabled", disabled: true) do |dropdown|
        dropdown.menu.build_item("Action 1", "#")
        dropdown.menu.build_item("Action 2", "#")
        dropdown.menu.build_item("Action 3", "#")
      end

      c << new_secondary_dropdown("Secondary Disabled", disabled: true) do |dropdown|
        dropdown.menu.build_item("Action 1", "#")
        dropdown.menu.build_item("Action 2", "#")
        dropdown.menu.build_item("Action 3", "#")
      end

      c << new_naked_dropdown("Naked Disabled", disabled: true) do |dropdown|
        dropdown.menu.build_item("Action 1", "#")
        dropdown.menu.build_item("Action 2", "#")
        dropdown.menu.build_item("Action 3", "#")
      end
    end
  end

  def component_controls_dropdowns_positioning
    demo_components do |c|
      c << new_primary_dropdown("Left Aligned") do |dropdown|
        dropdown.menu.build_item("Action 1", "#")
        dropdown.menu.build_item("Action 2", "#")
        dropdown.menu.build_item("Action 3", "#")
      end

      c << new_primary_dropdown("Right Aligned", align: "right") do |dropdown|
        dropdown.menu.build_item("Action 1", "#")
        dropdown.menu.build_item("Action 2", "#")
        dropdown.menu.build_item("Action 3", "#")
      end

      c << new_primary_dropdown("Center Aligned", align: "center") do |dropdown|
        dropdown.menu.build_item("Action 1", "#")
        dropdown.menu.build_item("Action 2", "#")
        dropdown.menu.build_item("Action 3", "#")
      end

      c << new_primary_dropdown("Drop Up", direction: "up") do |dropdown|
        dropdown.menu.build_item("Up", "#")
        dropdown.menu.build_item("Position", "#")
      end

      c << new_primary_dropdown("Drop Up-Right", align: "right", direction: "up") do |dropdown|
        dropdown.menu.build_item("Up", "#")
        dropdown.menu.build_item("Position", "#")
      end

      c << new_primary_dropdown("Drop Up-Center", align: "center", direction: "up") do |dropdown|
        dropdown.menu.build_item("Up", "#")
        dropdown.menu.build_item("Position", "#")
      end
    end
  end

  def component_controls_dropdowns_active_and_disabled
    demo_components do |c|
      c << new_primary_dropdown("Active & Disabled") do |dropdown|
        dropdown.menu.build_item("Active Item", "#", active: true)
        dropdown.menu.build_item("Normal Item", "#")
        dropdown.menu.build_item("Disabled Item", "#", disabled: true)
      end

      c << new_secondary_dropdown("With Icons") do |dropdown|
        dropdown.menu.build_item("Active Profile", "#", icon: "user", active: true)
        dropdown.menu.build_item("Settings", "#", icon: "settings")
        dropdown.menu.build_item("Disabled Billing", "#", icon: "hash", disabled: true)
      end

      c << new_success_dropdown("Success Variant") do |dropdown|
        dropdown.menu.build_item("Active Success", "#", active: true)
        dropdown.menu.build_item("Normal Success", "#")
        dropdown.menu.build_item("Disabled Success", "#", disabled: true)
      end

      c << new_danger_dropdown("Danger Variant") do |dropdown|
        dropdown.menu.build_item("Active Danger", "#", active: true)
        dropdown.menu.build_item("Normal Danger", "#")
        dropdown.menu.build_item("Disabled Danger", "#", disabled: true)
      end
    end
  end

  def component_controls_dropdowns_with_icons
    demo_components do |c|
      c << new_primary_dropdown(icon("user"), "Profile") do |dropdown|
        dropdown.menu.build_item("Profile", "#", icon: "user")
        dropdown.menu.build_item("Settings", "#", icon: "settings")
        dropdown.menu.build_item("Sign Out", "#", icon: "x")
      end

      c << new_secondary_dropdown(icon("settings"), "Options") do |dropdown|
        dropdown.menu.build_item("Search", "#", icon: "search")
        dropdown.menu.build_item("Help", "#", icon: "info")
        dropdown.menu.build_item("Delete", "#", icon: "trash")
      end

      c << new_success_dropdown("Skip Caret", skip_caret: true) do |dropdown|
        dropdown.menu.build_item("Search", "#", icon: "search")
        dropdown.menu.build_item("Help", "#", icon: "info")
        dropdown.menu.build_item("Delete", "#", icon: "trash")
      end

      c << new_danger_dropdown do |dropdown|
        dropdown.menu.build_item("Search", "#", icon: "search")
        dropdown.menu.build_item("Help", "#", icon: "info")
        dropdown.menu.build_item("Delete", "#", icon: "trash")
      end
    end
  end

  def component_controls_dropdowns_with_html_content
    demo_components do |c|
      c << new_primary_dropdown("Profile") do |dropdown|
        dropdown.menu << tag.p("This is some HTML content in the menu.", class: "m-2 text-white")
      end

      c << new_secondary_dropdown("Options") do |dropdown|
        dropdown.menu << %(
          <ul class="m-4">
            <li>Item 1.</li>
            <li>Item 2.</li>
            <li>Item 3.</li>
          </ul>
        ).html_safe
      end
    end
  end

  def component_controls_dropdowns_menu_headers_and_dividers
    demo_components do |c|
      c << new_primary_dropdown("Primary") do |dropdown|
        dropdown.menu.build_header("Account")
        dropdown.menu.build_item("Profile", "#")
        dropdown.menu.build_divider
        dropdown.menu.build_item("Sign Out", "#")
      end

      c << new_secondary_dropdown("Secondary") do |dropdown|
        dropdown.menu.build_header("Account")
        dropdown.menu.build_item("Profile", "#")
        dropdown.menu.build_divider
        dropdown.menu.build_item("Sign Out", "#")
      end

      c << new_naked_dropdown("Naked") do |dropdown|
        dropdown.menu.build_header("Account")
        dropdown.menu.build_item("Profile", "#")
        dropdown.menu.build_divider
        dropdown.menu.build_item("Sign Out", "#")
      end

      c << new_success_dropdown("Success") do |dropdown|
        dropdown.menu.build_header("Account")
        dropdown.menu.build_item("Profile", "#")
        dropdown.menu.build_divider
        dropdown.menu.build_item("Sign Out", "#")
      end

      c << new_warning_dropdown("Warning") do |dropdown|
        dropdown.menu.build_header("Account")
        dropdown.menu.build_item("Profile", "#")
        dropdown.menu.build_divider
        dropdown.menu.build_item("Sign Out", "#")
      end

      c << new_danger_dropdown("Danger") do |dropdown|
        dropdown.menu.build_header("Account")
        dropdown.menu.build_item("Profile", "#")
        dropdown.menu.build_divider
        dropdown.menu.build_item("Sign Out", "#")
      end

      c << new_outline_primary_dropdown("Outline Primary") do |dropdown|
        dropdown.menu.build_header("Account")
        dropdown.menu.build_item("Profile", "#")
        dropdown.menu.build_divider
        dropdown.menu.build_item("Sign Out", "#")
      end

      c << new_outline_success_dropdown("Outline Success") do |dropdown|
        dropdown.menu.build_header("Account")
        dropdown.menu.build_item("Profile", "#")
        dropdown.menu.build_divider
        dropdown.menu.build_item("Sign Out", "#")
      end

      c << new_outline_warning_dropdown("Outline Warning") do |dropdown|
        dropdown.menu.build_header("Account")
        dropdown.menu.build_item("Profile", "#")
        dropdown.menu.build_divider
        dropdown.menu.build_item("Sign Out", "#")
      end

      c << new_outline_danger_dropdown("Outline Danger") do |dropdown|
        dropdown.menu.build_header("Account")
        dropdown.menu.build_item("Profile", "#")
        dropdown.menu.build_divider
        dropdown.menu.build_item("Sign Out", "#")
      end
    end
  end
end
