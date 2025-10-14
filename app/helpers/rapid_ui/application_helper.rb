module RapidUI
  module ApplicationHelper
    def components(children = nil, &block)
      if children.is_a?(ApplicationComponent)
        children
      elsif children.is_a?(String)
        Text.new(children)
      elsif children.nil? && block_given?
        Html.new(capture(&block))
      else
        raise ArgumentError, "invalid children: #{children.class.name} block given: #{block_given?}"
      end
    end
  end
end
