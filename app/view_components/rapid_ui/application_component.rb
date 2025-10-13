require "view_component"

module RapidUI
  class ApplicationComponent < ViewComponent::Base
    with_options to: :view_context do
      delegate :asset_path
      delegate :image_path
    end
  end
end
