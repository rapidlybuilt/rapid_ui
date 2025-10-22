module RapidUI
  class Dropdown < ApplicationComponent
    erb_template <<~ERB
      <%= component_tag data: { controller: "dropdown" } do %>
        <%= button %>

        <div class="dropdown-menu" data-dropdown-target="menu" data-action="click->dropdown#close">
          <%= menu %>
        </div>
      <% end %>
    ERB

    attr_accessor :direction
    attr_accessor :align

    renders_one :button, ->(*args, **kwargs) do
      build(
        Button,
        *args,
        **kwargs,
        data: merge_data({ action: "click->dropdown#toggle" }, kwargs[:data]),
      )
    end

    renders_one :menu, ->(*args, variant: self.variant, **kwargs) do
      build(Menu, *args, variant:, **kwargs)
    end

    with_options to: :button do
      delegate :variant
      delegate :size
      delegate :disabled?
      delegate :disabled=
    end

    def initialize(*children, skip_caret: false, variant:, size: nil, disabled: false, align: nil, direction: "down", menu: nil, **kwargs)
      super(**kwargs)

      # TODO: simplify this, as it's pretty common
      if menu
        self.menu = menu
      else
        with_menu(variant:)
      end

      @align = align
      @direction = direction

      caret = build(ArrowIcon, direction:) unless skip_caret
      with_button(*children, caret, variant:, size:, disabled:)

      yield self if block_given?
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
        super(**kwargs)

        @name = name
        @path = path
        @icon = icon
        @variant = variant
        @active = active
        @disabled = disabled

        @icon = build(Icon, icon) if icon.is_a?(String) && !icon.html_safe?

        yield self if block_given?
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
        super(tag_name: :hr, **kwargs)

        @variant = variant

        yield self if block_given?
      end

      def call
        component_tag(class: "dropdown-divider")
      end
    end

    class Header < ApplicationComponent
      attr_accessor :name
      attr_accessor :variant

      def initialize(name, variant: nil, **kwargs, &block)
        super(**kwargs)

        @name = name
        @variant = variant

        yield self if block_given?
      end

      def call
        component_tag(name, class: "dropdown-header")
      end
    end

    class Menu < Components
      def initialize(*children, variant: nil, **kwargs, &block)
        super(children, **kwargs)

        @variant = variant

        yield self if block_given?
      end

      contains :item, ->(name, path, variant: nil, **kwargs, &block) do
        build(Item, name, path, variant: @variant, **kwargs, &block)
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
