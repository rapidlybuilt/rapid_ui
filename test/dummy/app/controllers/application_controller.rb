class ApplicationController < ActionController::Base
  extend RapidUI::UsesLayout

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  uses_application_layout

  helper RapidUI::IconsHelper

  before_action :setup_layout

  private

  def setup_layout
    layout.head.tap do |head|
      head.site_name = "Dummy"

      head.favicons.build("rapid_ui/favicon-32x32.png", type: "image/png", size: 32)
      head.favicons.build("rapid_ui/favicon-16x16.png", type: "image/png", size: 16)
      head.favicons.build_apple_touch("rapid_ui/apple-touch-icon.png")
    end
  end
end
