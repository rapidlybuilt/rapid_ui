module RapidUI
  module SharedHelper
    def safe_component(component = nil, block_context: nil, &block)
      if block_given?
        raise ArgumentError, "cannot pass children and a block" if component
        return Html.new(capture(block_context, &block))
      end

      ApplicationComponent.safe_component(component)
    end

    def safe_components(*components, block_context: nil, &block)
      if block_given?
        raise ArgumentError, "cannot pass children and a block" if components&.any?
        return Components.new(safe_component(nil, block_context:, &block))
      end

      ApplicationComponent.safe_components(*components)
    end

    def new_icon(name, size: nil, spin: false, **kwargs)
      Icon.new(name, size:, spin:, **kwargs)
    end

    def icon(name, size: nil, spin: false, **kwargs)
      render new_icon(name, size:, spin:, **kwargs)
    end
  end
end
