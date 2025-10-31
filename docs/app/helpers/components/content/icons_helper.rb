module Components::Content::IconsHelper
  def component_content_icons_helper
    demo_components do |c|
      c << new_icon("user")
    end
  end
end
