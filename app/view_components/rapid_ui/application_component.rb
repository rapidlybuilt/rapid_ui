require "view_component"

module RapidUI
  class ApplicationComponent < ViewComponent::Base
    # TODO: organize more (break into modules?)
    include HasComponentTag
    include RendersWithFactory
    include Support::I18n
    extend RendersPolymorphic

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

    private

    def safe_join(components, sep = $,)
      super(components.map { |p| p.is_a?(ViewComponent::Base) ? render(p) : p.to_s }, sep)
    end
  end
end
