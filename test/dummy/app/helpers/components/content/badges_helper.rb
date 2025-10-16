module Components::Content::BadgesHelper
  def component_content_badge_variants
    demo_components do |c|
      c << new_light_primary_badge("Light Primary")
      c << new_light_secondary_badge("Light Secondary")
      c << new_dark_primary_badge("Dark Primary")
      c << new_dark_secondary_badge("Dark Secondary")
      c << new_success_badge("Success")
      c << new_danger_badge("Danger")
      c << new_warning_badge("Warning")
      c << new_info_badge("Info")
    end
  end

  def component_content_badge_pills
    demo_components do |c|
      c << new_light_primary_pill_badge("Light Primary")
      c << new_light_secondary_pill_badge("Light Secondary")
      c << new_dark_primary_pill_badge("Dark Primary")
      c << new_dark_secondary_pill_badge("Dark Secondary")
      c << new_success_pill_badge("Success")
      c << new_danger_pill_badge("Danger")
      c << new_warning_pill_badge("Warning")
      c << new_info_pill_badge("Info")
    end
  end

  def component_content_badge_sizes
    demo_components do |c|
      c << new_dark_primary_badge("X-Small", class: "text-xs")
      c << new_dark_primary_badge("Small", class: "text-sm")
      c << new_dark_primary_badge("Medium (Default)")
      c << new_dark_primary_badge("Large", class: "text-lg")
      c << new_dark_primary_badge("X-Large", class: "text-xl")
    end
  end

  def component_content_badge_buttons
    demo_components do |c|
      c << new_primary_button("Notifications", new_danger_badge(5))
      c << new_secondary_button("Messages", new_success_badge(12))
      c << new_success_button("Completed", new_dark_primary_badge(24))
      c << new_warning_button("Pending", new_light_primary_badge(3))
      c << new_danger_button("Errors", new_light_primary_badge(1))
      c << new_outline_primary_button("Drafts", new_info_badge(7))
    end
  end

  def component_content_badge_html_content
    demo_components do |c|
      c << new_warning_badge.with_content(tag.strong("New"))
    end
  end
end
