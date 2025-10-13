class ApplicationController < ActionController::Base
  extend RapidUI::UsesLayout

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  uses_application_layout

  helper RapidUI::IconsHelper

  before_action :setup_layout

  private

  def setup_layout
    sidebar_closed = cookies[:sidebar_closed] == "1"

    layout.head.tap do |head|
      head.site_name = "Dummy"

      head.favicons.build("rapid_ui/favicon-32x32.png", type: "image/png", size: 32)
      head.favicons.build("rapid_ui/favicon-16x16.png", type: "image/png", size: 16)
      head.favicons.build_apple_touch("rapid_ui/apple-touch-icon.png")
    end

    layout.header.tap do |header|
      header.left.tap do |left|
        left.build_text_button("Rapid", root_path)

        left.build_menu do |menu|
          menu.icon.id = "menu"

          menu.items.build("Builds & Deploys", "#")
          menu.items.build("Code Coverage", "#")
          menu.items.build("Errors", "#")
          menu.items.build_divider
          menu.items.build("Content Management", "#")
          menu.items.build("Users", "#")
        end

        left.build_search(path: search_path)
      end

      header.right.tap do |right|
        right.build_text("username")

        right.build_icon_button("hash", "#")
        right.build_icon_button("info", "#")
        right.build_icon_button("circle-question-mark", "#")
        right.build_icon_button("settings", "#")

        right.build_menu do |menu|
          menu.name = "username"
          menu.align_right = true

          menu.items.build("Profile Settings", "#")
          menu.items.build("Account Preferences", "#")
          menu.items.build("Billing & Plans", "#")
          menu.items.build_divider
          menu.items.build("Help & Support", "#")
          menu.items.build("Sign Out", "#")
        end
      end
    end

    layout.subheader.tap do |subheader|
      subheader.sidebar_toggle.closed = sidebar_closed

      subheader.breadcrumbs.build("Home", "#")
      subheader.breadcrumbs.build("Breadcrumb 2", "#")
      subheader.breadcrumbs.build("Current Page")

      subheader.buttons.build(:info, "#")
      subheader.buttons.build(:settings, "#")
      subheader.buttons.build(:help, "#")
    end
  end
end
