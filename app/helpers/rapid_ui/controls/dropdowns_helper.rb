module RapidUI
  module Controls
    module DropdownsHelper
      include IconsHelper

      def new_dropdown(*args, **kwargs, &block)
        rapid_ui.build Dropdown, *args, **kwargs, &block
      end

      def dropdown(*button_children, menu: nil, variant:, **kwargs, &block)
        if block_given?
          menu = rapid_ui.build(Dropdown::Menu, variant:)
          capture(menu, &block)
        end

        render new_dropdown(*button_children, menu:, variant:, **kwargs)
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
