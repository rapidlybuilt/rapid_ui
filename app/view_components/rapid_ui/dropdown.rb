module RapidUI
  class Dropdown < ApplicationComponent
    # attr_accessor :button
    # attr_accessor :menu
    attr_accessor :direction
    attr_accessor :align

    renders_one :button, Button
    renders_one :menu, "Menu"

    with_options to: :button do
      delegate :variant
      delegate :size
      delegate :disabled?
      delegate :disabled=
      delegate :icon
    end

    def initialize(*children, icon: nil, variant:, size: nil, disabled: false, align: nil, direction: nil, **kwargs, &block)
      with_menu variant:
      @align = align
      @direction = direction

      icon = Icon.new(default_icon, class: "dropdown-arrow") if icon.nil? && icon != false
      children = safe_components(*children, icon)

      with_button(
        children,
        variant:,
        size:,
        disabled:,
        data: { action: "click->dropdown#toggle" },
      )

      super(**kwargs, &block)
    end

    def default_icon
      direction == "up" ? "chevron-up" : "chevron-down"
    end

    def name
      button.content.first
    end

    def name=(name)
      component = button.content.find(Text)

      unless component
        component = Text.new(name)
        button.content.insert(0, component)
      end

      component.text = name
    end

    def icon
      button.content.find(Icon)
    end

    def dynamic_css_class
      combine_classes(
        "dropdown",
        ("dropdown-#{variant}" if variant),
        ("dropdown-#{size}" if size),
        ("dropdown-#{align}" if align),
        ("dropdown-#{direction}" if direction),
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

      def initialize(name, path, icon: nil, variant: nil, active: false, disabled: false, **kwargs, &block)
        @name = name
        @path = path
        @icon = icon
        @variant = variant
        @active = active
        @disabled = disabled

        @icon = Icon.new(icon) if icon.is_a?(String) && !icon.html_safe?

        super(**kwargs, &block)
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

      def dynamic_tag_name
        disabled? ? :span : :a
      end

      def call
        content = render(safe_components(icon, name))

        if disabled?
          component_tag(content)
        else
          component_tag(content, href: path)
        end
      end
    end

    class Divider < ApplicationComponent
      attr_accessor :variant

      def initialize(variant: nil, **kwargs, &block)
        @variant = variant

        super(tag_name: :hr, **kwargs, &block)
      end

      def call
        component_tag(class: "dropdown-divider")
      end
    end

    class Header < ApplicationComponent
      attr_accessor :name
      attr_accessor :variant

      def initialize(name, variant: nil, **kwargs, &block)
        @name = name
        @variant = variant

        super(**kwargs, &block)
      end

      def call
        component_tag(name, class: "dropdown-header")
      end
    end

    class Menu < Components
      def initialize(variant: nil, **kwargs, &block)
        @variant = variant

        super(**kwargs, &block)
      end

      contains Item, :item do |name, path, variant: nil, **kwargs, &block|
        Item.new(name, path, variant: @variant, **kwargs, &block)
      end

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
