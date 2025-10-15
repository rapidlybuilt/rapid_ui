module RapidUI
  module Controls
    module DropdownsHelper
      def dropdown(text, icon: nil, menu: nil, variant:, size: nil, disabled: false, **kwargs, &block)
        menu = components(menu, context: Builder.new(self, variant:), &block)
        icon = Html.new(icon) unless icon == false || icon.nil?

        render Dropdown.new(Html.new(text), icon:, menu:, variant:, size:, disabled:, **kwargs)
      end

      def dropdown_menu_item(name = nil, path = nil, icon: nil, variant: nil, active: false, disabled: false, **kwargs, &block)
        if block_given?
          path = name
          name = components(&block).html
        end

        icon = self.icon(icon) if icon.is_a?(String) && !icon.html_safe?

        render Dropdown::Item.new(name, path, icon:, variant:, active:, disabled:, **kwargs)
      end

      def dropdown_menu_divider(variant: nil, **kwargs)
        render Dropdown::Divider.new(variant:, **kwargs)
      end

      def dropdown_menu_header(name, variant: nil, **kwargs)
        render Dropdown::Header.new(name, variant:, **kwargs)
      end

      Dropdown.variants.each do |variant|
        define_method(:"#{variant.underscore}_dropdown") do |*args, **kwargs, &block|
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
