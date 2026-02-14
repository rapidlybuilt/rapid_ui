require "view_component"

module RapidUI
  class ApplicationComponent < ViewComponent::Base
    extend RendersPolymorphic

    include HasComponentTag
    include RendersWithFactory

    include Support::I18n
    include Support::HasParams
    include Support::HasStimulusController

    class_attribute :partial_path
    self.partial_path = "rapid_ui/component"

    with_options to: :view_context do
      # Rails helpers
      delegate :asset_path
      delegate :image_path
      delegate :image_tag
    end

    def initialize(tag_name: :div, id: nil, data: {}, factory:, **kwargs)
      super()

      initialize_component_tag(tag_name:, id:, data:, **kwargs)

      self.factory = factory
      raise ArgumentError, "factory is required" unless factory
    end

    def safe_join(components, sep = $,)
      super(components.map { |p| p.is_a?(ViewComponent::Base) ? render(p) : p.to_s }, sep)
    end

    def dynamic_data
      merge_data(
        data,
        ({ controller: stimulus_controller.name } if stimulus_controller.valid?),
      )
    end
  end
end
