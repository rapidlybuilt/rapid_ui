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
end
