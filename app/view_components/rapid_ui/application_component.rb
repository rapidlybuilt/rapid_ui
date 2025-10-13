require "view_component"

module RapidUI
  class ApplicationComponent < ViewComponent::Base
    with_options to: :view_context do
      # Rails helpers
      delegate :asset_path
      delegate :image_path
      delegate :image_tag
    end

    private

    def combine_classes(classes, *additional_classes)
      [classes, *additional_classes].compact.join(" ")
    end
  end
end
