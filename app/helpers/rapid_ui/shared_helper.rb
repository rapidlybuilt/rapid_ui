module RapidUI
  module SharedHelper
    # TODO: rethink this?
    def components(children = nil, context: nil, &block)
      case children
      when ApplicationComponent
        children
      when String
        Text.new(children)
      when NilClass
        block_given? ? Html.new(capture(context, &block)) : nil
      else
        raise ArgumentError, "invalid children: #{children.class.name} block given: #{block_given?}"
      end
    end

    def safe_component(component)
      ApplicationComponent.safe_component(component)
    end

    def safe_components(*components)
      ApplicationComponent.safe_components(*components)
    end

    def icon(name, size: nil, spin: false, **options)
      render Icon.new(name, size:, spin:, **options)
    end
  end
end
