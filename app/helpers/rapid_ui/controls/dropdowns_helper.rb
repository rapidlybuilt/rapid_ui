module RapidUI
  module Controls
    module DropdownsHelper
      include SharedHelper

      def new_dropdown(*args, **kwargs, &block)
        Dropdown.new(*args, **kwargs, &block)
      end

      def new_dropdown_menu(*args, **kwargs, &block)
        Dropdown::Menu.new(*args, **kwargs, &block)
      end

      def new_dropdown_menu_item(*args, **kwargs, &block)
        Dropdown::Item.new(*args, **kwargs, &block)
      end

      def new_dropdown_menu_divider(*args, **kwargs, &block)
        Dropdown::Divider.new(*args, **kwargs, &block)
      end

      def new_dropdown_menu_header(*args, **kwargs, &block)
        Dropdown::Header.new(*args, **kwargs, &block)
      end

      def dropdown(*button_children, menu: nil, variant:, **kwargs, &block)
        if block_given?
          menu = new_dropdown_menu(variant:)
          capture(menu, &block)
        end

        render new_dropdown(*button_children, menu:, variant:, **kwargs)
      end

      def dropdown_menu_item(name = nil, path = nil, icon: nil, variant: nil, active: false, disabled: false, **kwargs, &block)
        # TODO: raw HTML in menu items via this helper?
        # if block_given?
        #   path = name
        #   name = safe_components(&block).html
        # end

        icon = self.icon(icon) if icon.is_a?(String) && !icon.html_safe?

        render new_dropdown_menu_item(name, path, icon:, variant:, active:, disabled:, **kwargs)
      end

      def dropdown_menu_divider(variant: nil, **kwargs)
        render new_dropdown_menu_divider(variant:, **kwargs)
      end

      def dropdown_menu_header(name, variant: nil, **kwargs)
        render new_dropdown_menu_header(name, variant:, **kwargs)
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

      class Builder
        def initialize(context, variant: nil)
          @context = context
          @variant = variant
        end

        def item(*args, **kwargs, &block)
          @context.dropdown_menu_item(*args, **kwargs, variant: @variant, &block)
        end

        def divider(*args, **kwargs)
          @context.dropdown_menu_divider(*args, **kwargs, variant: @variant)
        end

        def header(*args, **kwargs)
          @context.dropdown_menu_header(*args, **kwargs, variant: @variant)
        end
      end
    end
  end
end
