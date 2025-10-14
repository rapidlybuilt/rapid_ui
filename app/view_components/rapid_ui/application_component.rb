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

    def t(key, **kwargs)
      key = "#{i18n_scope}.#{key}" if key[0] == "."
      I18n.t(key, **kwargs)
    end

    def i18n_scope
      "#{self.class.name.underscore.gsub("/", ".")}"
    end
  end
end
