module RapidUI
  module Controls
    module ButtonsHelper
      def button(children = nil, **kwargs, &block)
        children = components(children, &block)
        render Button.new(children:, **kwargs)
      end

      Button.variants.each do |variant|
        define_method(:"#{variant.underscore}_button") do |children = nil, **kwargs, &block|
          button(children, **kwargs, variant:, &block)
        end
      end
    end
  end
end
