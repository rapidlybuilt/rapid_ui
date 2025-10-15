module Components::Controls::DropdownsHelper
  def component_controls_dropdowns_variants
    demo_components do |c|
      c << new_primary_dropdown("Primary") do |d|
        d.menu.build_item("Action 1", "#")
        d.menu.build_item("Action 2", "#")
        d.menu.build_divider
        d.menu.build_item("Action 3", "#")
      end

      c << new_secondary_dropdown("Secondary") do |d|
        d.menu.build_item("Action 1", "#")
        d.menu.build_item("Action 2", "#")
        d.menu.build_divider
        d.menu.build_item("Action 3", "#")
      end

      c << new_naked_dropdown("Naked") do |d|
        d.menu.build_item("Action 1", "#")
        d.menu.build_item("Action 2", "#")
        d.menu.build_divider
        d.menu.build_item("Action 3", "#")
      end

      c << new_success_dropdown("Success") do |d|
        d.menu.build_item("Action 1", "#")
        d.menu.build_item("Action 2", "#")
        d.menu.build_divider
        d.menu.build_item("Action 3", "#")
      end

      c << new_warning_dropdown("Warning") do |d|
        d.menu.build_item("Action 1", "#")
        d.menu.build_item("Action 2", "#")
        d.menu.build_divider
        d.menu.build_item("Action 3", "#")
      end

      c << new_danger_dropdown("Danger") do |d|
        d.menu.build_item("Action 1", "#")
        d.menu.build_item("Action 2", "#")
        d.menu.build_divider
        d.menu.build_item("Action 3", "#")
      end
    end
  end

  def component_controls_dropdowns_outline_variants
    demo_components do |c|
      c << new_outline_primary_dropdown("Outline Primary") do |d|
        d.menu.build_item("Action 1", "#")
        d.menu.build_item("Action 2", "#")
        d.menu.build_divider
        d.menu.build_item("Action 3", "#")
      end

      c << new_outline_success_dropdown("Outline Success") do |d|
        d.menu.build_item("Action 1", "#")
        d.menu.build_item("Action 2", "#")
        d.menu.build_divider
        d.menu.build_item("Action 3", "#")
      end

      c << new_outline_warning_dropdown("Outline Warning") do |d|
        d.menu.build_item("Action 1", "#")
        d.menu.build_item("Action 2", "#")
        d.menu.build_divider
        d.menu.build_item("Action 3", "#")
      end

      c << new_outline_danger_dropdown("Outline Danger") do |d|
        d.menu.build_item("Action 1", "#")
        d.menu.build_item("Action 2", "#")
        d.menu.build_divider
        d.menu.build_item("Action 3", "#")
      end
    end
  end

  def component_controls_dropdowns_sizes
    demo_components do |c|
      c << new_primary_dropdown("Small", size: "sm") do |d|
        d.menu.build_item("Action 1", "#")
        d.menu.build_item("Action 2", "#")
        d.menu.build_item("Action 3", "#")
      end

      c << new_primary_dropdown("Medium (Default)") do |d|
        d.menu.build_item("Action 1", "#")
        d.menu.build_item("Action 2", "#")
        d.menu.build_item("Action 3", "#")
      end

      c << new_primary_dropdown("Large", size: "lg") do |d|
        d.menu.build_item("Action 1", "#")
        d.menu.build_item("Action 2", "#")
        d.menu.build_item("Action 3", "#")
      end
    end
  end

  def component_controls_dropdowns_disabled
    demo_components do |c|
      c << new_primary_dropdown("Primary Disabled", disabled: true) do |d|
        d.menu.build_item("Action 1", "#")
        d.menu.build_item("Action 2", "#")
        d.menu.build_item("Action 3", "#")
      end

      c << new_secondary_dropdown("Secondary Disabled", disabled: true) do |d|
        d.menu.build_item("Action 1", "#")
        d.menu.build_item("Action 2", "#")
        d.menu.build_item("Action 3", "#")
      end

      c << new_naked_dropdown("Naked Disabled", disabled: true) do |d|
        d.menu.build_item("Action 1", "#")
        d.menu.build_item("Action 2", "#")
        d.menu.build_item("Action 3", "#")
      end
    end
  end

  def component_controls_dropdowns_positioning
    demo_components do |c|
      c << new_primary_dropdown("Left Aligned") do |d|
        d.menu.build_item("Action 1", "#")
        d.menu.build_item("Action 2", "#")
        d.menu.build_item("Action 3", "#")
      end

      c << new_primary_dropdown("Right Aligned", align: "right") do |d|
        d.menu.build_item("Action 1", "#")
        d.menu.build_item("Action 2", "#")
        d.menu.build_item("Action 3", "#")
      end

      c << new_primary_dropdown("Center Aligned", align: "center") do |d|
        d.menu.build_item("Action 1", "#")
        d.menu.build_item("Action 2", "#")
        d.menu.build_item("Action 3", "#")
      end

      c << new_primary_dropdown("Drop Up", direction: "up") do |d|
        d.menu.build_item("Up", "#")
        d.menu.build_item("Position", "#")
      end

      c << new_primary_dropdown("Drop Up-Right", align: "right", direction: "up") do |d|
        d.menu.build_item("Up", "#")
        d.menu.build_item("Position", "#")
      end

      c << new_primary_dropdown("Drop Up-Center", align: "center", direction: "up") do |d|
        d.menu.build_item("Up", "#")
        d.menu.build_item("Position", "#")
      end
    end
  end

  def component_controls_dropdowns_active_and_disabled
    demo_components do |c|
      c << new_primary_dropdown("Active & Disabled") do |d|
        d.menu.build_item("Active Item", "#", active: true)
        d.menu.build_item("Normal Item", "#")
        d.menu.build_item("Disabled Item", "#", disabled: true)
        d.menu.build_divider
        d.menu.build_item("Another Normal Item", "#")
      end

      c << new_secondary_dropdown("With Icons") do |d|
        d.menu.build_item("Active Profile", "#", icon: "user", active: true)
        d.menu.build_item("Settings", "#", icon: "settings")
        d.menu.build_item("Disabled Billing", "#", icon: "hash", disabled: true)
      end

      c << new_success_dropdown("Success Variant") do |d|
        d.menu.build_item("Active Success", "#", active: true)
        d.menu.build_item("Normal Success", "#")
        d.menu.build_item("Disabled Success", "#", disabled: true)
      end

      c << new_danger_dropdown("Danger Variant") do |d|
        d.menu.build_item("Active Danger", "#", active: true)
        d.menu.build_item("Normal Danger", "#")
        d.menu.build_item("Disabled Danger", "#", disabled: true)
      end
    end
  end

  def component_controls_dropdowns_with_icons
    demo_components do |c|
      c << new_primary_dropdown(icon("user"), "Profile") do |d|
        d.menu.build_item("Profile", "#", icon: "user")
        d.menu.build_item("Settings", "#", icon: "settings")
        d.menu.build_item("Sign Out", "#", icon: "x")
      end

      c << new_secondary_dropdown(icon("settings"), "Options") do |d|
        d.menu.build_item("Search", "#", icon: "search")
        d.menu.build_item("Help", "#", icon: "info")
        d.menu.build_item("Delete", "#", icon: "trash")
      end
    end
  end

  def component_controls_dropdowns_with_html_content
    demo_components do |c|
      c << new_primary_dropdown("Profile") do |d|
        d.menu << tag.p("This is some HTML content in the menu.", class: "m-2 text-white")
      end

      c << new_secondary_dropdown("Options") do |d|
        d.menu << %(
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
      c << new_primary_dropdown("Primary Structure") do |d|
        d.menu.build_header("Account")
        d.menu.build_item("Profile", "#")
        d.menu.build_item("Settings", "#")
        d.menu.build_item("Billing", "#")
        d.menu.build_divider
        d.menu.build_header("Actions")
        d.menu.build_item("Export Data", "#")
        d.menu.build_item("Import Data", "#")
        d.menu.build_divider
        d.menu.build_item("Sign Out", "#")
      end

      c << new_secondary_dropdown("Secondary Structure") do |d|
        d.menu.build_header("Account")
        d.menu.build_item("Profile", "#")
      end

      c << new_naked_dropdown("Naked Structure") do |d|
        d.menu.build_header("Account")
        d.menu.build_item("Profile", "#")
      end

      c << new_success_dropdown("Success Structure") do |d|
        d.menu.build_header("Account")
        d.menu.build_item("Profile", "#")
      end

      c << new_warning_dropdown("Warning Structure") do |d|
        d.menu.build_header("Account")
        d.menu.build_item("Profile", "#")
      end

      c << new_danger_dropdown("Danger Structure") do |d|
        d.menu.build_header("Account")
        d.menu.build_item("Profile", "#")
      end

      c << new_outline_primary_dropdown("Outline Primary Structure") do |d|
        d.menu.build_header("Account")
        d.menu.build_item("Profile", "#")
      end

      c << new_outline_success_dropdown("Outline Success Structure") do |d|
        d.menu.build_header("Account")
        d.menu.build_item("Profile", "#")
      end

      c << new_outline_warning_dropdown("Outline Warning Structure") do |d|
        d.menu.build_header("Account")
        d.menu.build_item("Profile", "#")
      end

      c << new_outline_danger_dropdown("Outline Danger Structure") do |d|
        d.menu.build_header("Account")
        d.menu.build_item("Profile", "#")
      end
    end
  end
end
