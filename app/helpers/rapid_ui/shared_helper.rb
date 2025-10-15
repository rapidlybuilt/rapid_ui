module RapidUI
  module SharedHelper
    def components(children = nil, context: nil, &block)
      if children.is_a?(ApplicationComponent)
        children
      elsif children.is_a?(String)
        Text.new(children)
      elsif children.nil? && block_given?
        Html.new(capture(context, &block))
      else
        raise ArgumentError, "invalid children: #{children.class.name} block given: #{block_given?}"
      end
    end

    def icon(name, size: nil, spin: false, **options)
      render Icon.new(name, size:, spin:, **options)
    end
  end
end
