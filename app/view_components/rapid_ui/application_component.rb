require "view_component"

module RapidUI
  class ApplicationComponent < ViewComponent::Base
    with_options to: :view_context do
      # Rails helpers
      delegate :asset_path
      delegate :image_path

      # RapidUI helpers
      delegate :icon_tag
    end
  end
end
