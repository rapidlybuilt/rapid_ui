module RapidUI
  class Dropdown < ApplicationComponent
    attr_accessor :direction
    attr_accessor :align

    renders_one :button, ->(*args, **kwargs) do
      Button.new(
        *args,
        **kwargs,
        data: merge_data({ action: "click->dropdown#toggle" }, kwargs[:data]),
      )
    end

    renders_one :menu, ->(*args, variant: self.variant, **kwargs) do
      Menu.new(*args, variant:, **kwargs)
    end

    with_options to: :button do
      delegate :variant
      delegate :size
      delegate :disabled?
      delegate :disabled=
    end

    def initialize(*children, skip_caret: false, variant:, size: nil, disabled: false, align: nil, direction: "down", menu: Menu.new(variant:), **kwargs, &block)
      self.menu = menu

      @align = align
      @direction = direction

      caret = ArrowIcon.new(direction:) unless skip_caret
      with_button(*children, caret, variant:, size:, disabled:)

      super(**kwargs, &block)
    end

    private

    def dynamic_css_class
      merge_classes(
        "dropdown",
        ("dropdown-#{variant}" if variant),
        ("dropdown-#{size}" if size),
        ("dropdown-#{align}" if align),
        ("dropdown-#{direction}" if direction),
        super,
      )
    end

    class ArrowIcon < Icon
      def initialize(direction: "down", id: default_icon(direction), **kwargs, &block)
        super(id, **kwargs, class: merge_classes("dropdown-arrow", kwargs[:class]), &block)
      end

      def default_icon(direction)
        direction == "down" ? "chevron-down" : "chevron-up"
      end
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
        merge_classes(
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
      def initialize(*children, variant: nil, **kwargs, &block)
        @variant = variant

        super(children, **kwargs, &block)
      end

      contains :item do |name, path, variant: nil, **kwargs, &block|
        Item.new(name, path, variant: @variant, **kwargs, &block)
      end

      contains :divider, Divider
      contains :header, Header
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
