module RapidUI
  module Controls
    module DropdownsHelper
      include SharedHelper

      def new_dropdown(*button_body, **kwargs, &block)
        ui.build(Dropdown, **kwargs) do |dropdown|
          # new_component_content(dropdown, body, &block)
          dropdown.with_button(*button_body) if button_body.any?
          yield dropdown if block_given?
        end
      end

      def dropdown(*button_body, **kwargs, &block)
        render new_dropdown(*button_body, **kwargs) do |dropdown|
          dropdown.with_button(*button_body) if button_body.any?
          yield dropdown.with_menu if block_given?
        end
      end

      Dropdown.variants.each do |variant|
        method_variant = variant.underscore

        define_method(:"new_#{method_variant}_dropdown") do |*args, **kwargs, &block|
          new_dropdown(*args, **kwargs, variant:, &block)
        end

        define_method(:"#{method_variant}_dropdown") do |*args, **kwargs, &block|
          dropdown(*args, **kwargs, variant:, &block)
        end
      end
    end
  end
end
