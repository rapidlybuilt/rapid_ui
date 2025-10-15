module RapidUI
  class Dropdown < ApplicationComponent
    attr_accessor :button
    attr_accessor :menu
    attr_accessor :align

    with_options to: :button do
      delegate :variant
      delegate :size
      delegate :disabled?
      delegate :disabled=
      delegate :icon
    end

    def initialize(text, icon:, menu: Menu.new, variant:, size: nil, disabled: false, align: nil, **kwargs)
      super(**kwargs)

      icon = Icon.new("chevron-down", class: "dropdown-arrow") if icon.nil?

      children = Components.new
      children << text if text
      children << icon if icon

      @button = Button.new(
        children:,
        variant:,
        size:,
        disabled:,
        data: { action: "click->dropdown#toggle" },
      )
      @menu = menu
      @align = align
    end

    def name
      @button.children.first
    end

    def name=(name)
      component = @button.children.find(Text)

      unless component
        component = Text.new(name)
        @button.children.insert(0, component)
      end

      component.text = name
    end

    def icon
      @button.children.find(Icon)
    end

    def dynamic_css_class
      combine_classes(
        "dropdown",
        ("dropdown-#{variant}" if variant),
        ("dropdown-#{size}" if size),
        ("dropdown-#{align}" if align),
        super,
      )
    end

    class Item < ApplicationComponent
      attr_accessor :name
      attr_accessor :path
      attr_accessor :icon
      attr_accessor :variant
      attr_accessor :active
      attr_accessor :disabled

      alias_method :active?, :active
      alias_method :disabled?, :disabled

      def initialize(name, path, icon: nil, variant: nil, active: false, disabled: false, **kwargs)
        super(**kwargs)

        @name = name
        @path = path
        @icon = icon
        @variant = variant
        @active = active
        @disabled = disabled
      end

      def dynamic_css_class
        combine_classes(
          "dropdown-menu-item",
          ("btn-#{variant}" if variant),
          ("active" if active?),
          ("disabled" if disabled?),
          super,
        )
      end

      def call
        content = []
        content << icon if icon
        content << name

        if disabled?
          component_tag(:span, content.join.html_safe)
        else
          component_tag(:a, content.join.html_safe, href: path)
        end
      end
    end

    class Divider < ApplicationComponent
      attr_accessor :variant

      def initialize(variant: nil, **kwargs)
        super(**kwargs)

        @variant = variant
      end

      def call
        component_tag(:hr, class: "dropdown-divider")
      end
    end

    class Header < ApplicationComponent
      attr_accessor :name
      attr_accessor :variant

      def initialize(name, variant: nil, **kwargs)
        super(**kwargs)

        @name = name
        @variant = variant
      end

      def call
        component_tag(:div, name, class: "dropdown-header")
      end
    end

    class Menu < Components
      contains Item, :item
      contains Divider, :divider
      contains Header, :header
    end

    class << self
      def variants
        [
          "primary", "secondary", "outline-primary", "naked", "success", "warning", "danger",
          "outline-success", "outline-warning", "outline-danger",
        ]
      end
    end
  end
end
