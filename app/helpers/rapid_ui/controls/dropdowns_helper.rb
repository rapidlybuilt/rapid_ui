module RapidUI
  module Controls
    module DropdownsHelper
      def new_dropdown(*button_body, **kwargs, &block)
        ui.build Dropdown, **kwargs do |dropdown|
          dropdown.with_button(*button_body) if button_body.any?
          block.call(dropdown) if block
        end
      end

      def dropdown(*button_body, **kwargs, &block)
        render new_dropdown(*button_body, **kwargs) do |dropdown|
          dropdown.with_button(*button_body) if button_body.any?
          dropdown.with_menu(&block)
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
