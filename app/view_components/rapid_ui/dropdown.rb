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
    attr_accessor :skip_caret
    alias_method :skip_caret?, :skip_caret

    attr_accessor :variant
    attr_accessor :size
    attr_accessor :disabled
    alias_method :disabled?, :disabled

    renders_one :button, ->(*body, skip_caret: self.skip_caret?, **kwargs, &block) do
      build(Button, variant:, size:, disabled:, **kwargs) do |btn|
        btn.data = merge_data(btn.data, { action: "click->dropdown#toggle" })

        body << build(ArrowIcon, direction:) unless block || skip_caret
        new_component_content(btn, body, &block)
      end
    end

    renders_one :menu, ->(*body, variant: self.variant, **kwargs, &block) do
      build(Menu, variant:, **kwargs) do |menu|
        new_component_content(menu, body, &block)
      end
    end

    def initialize(variant:, skip_caret: false, size: nil, disabled: false, align: nil, direction: "down", **kwargs)
      super(**kwargs)

      @skip_caret = skip_caret
      @align = align
      @direction = direction

      # button attributes
      @variant = variant
      @size = size
      @disabled = disabled

      yield self if block_given?
    end

    private

    def before_render
      super
      with_button unless button?
    end

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
      def initialize(direction: "down", name: default_icon(direction), **kwargs, &block)
        super(name, **kwargs, class: merge_classes("dropdown-arrow", kwargs[:class]), &block)
      end

      def default_icon(direction)
        direction == "down" ? "chevron-down" : "chevron-up"
      end
    end

    class Item < ApplicationComponent
      attr_accessor :path
      attr_accessor :variant
      attr_accessor :active
      attr_accessor :disabled

      alias_method :active?, :active
      alias_method :disabled?, :disabled

      renders_one :icon, Icon

      def initialize(path, variant: nil, active: false, disabled: false, **kwargs, &block)
        super(**kwargs, class: merge_classes("dropdown-menu-item", kwargs[:class]))

        @path = path
        @variant = variant
        @active = active
        @disabled = disabled

        # @icon = build(Icon, icon) if icon.is_a?(String) && !icon.html_safe?

        yield self if block_given?
      end

      def dynamic_css_class
        merge_classes(
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
        # Capture content before passing to safe_join_components to avoid consumption
        text_content = content
        combined_content = safe_join_components([ icon, text_content ])

        if disabled?
          component_tag(combined_content)
        else
          component_tag(combined_content, href: path)
        end
      end
    end

    class Header < ApplicationComponent
      attr_accessor :variant

      def initialize(variant: nil, **kwargs, &block)
        super(**kwargs, class: merge_classes("dropdown-header", kwargs[:class]))

        @variant = variant

        yield self if block_given?
      end

      def call
        component_tag { content }
      end
    end

    class Divider < ApplicationComponent
      attr_accessor :variant

      def initialize(variant: nil, **kwargs, &block)
        super(tag_name: :hr, **kwargs, class: merge_classes("dropdown-divider", kwargs[:class]))

        @variant = variant

        yield self if block_given?
      end

      def call
        component_tag
      end
    end

    class Menu < ApplicationComponent
      attr_accessor :variant

      renders_many :children, ->(type, *body, icon: nil, **kwargs, &block) do
        case type
        when :item
          *body, path = body # HACK: weird API?
          build(Item, path, **kwargs) do |item|
            new_component_content(item, body, &block)

            raise ArgumentError if icon && !icon.is_a?(String)
            item.with_icon(icon) if icon
          end
        when :header
          build(Header, **kwargs) do |header|
            new_component_content(header, body, &block)
          end
        when :divider
          build(Divider, **kwargs)
        else
          raise ArgumentError, "invalid child type: #{type}"
        end
      end

      def initialize(variant: nil, **kwargs, &block)
        super(**kwargs)

        @variant = variant

        yield self if block_given?
      end

      def call
        safe_join_components(children)
      end

      def with_item(name, path, variant: nil, active: false, disabled: false, **kwargs, &block)
        with_child(:item, name, path, variant:, active:, disabled:, **kwargs, &block)
      end

      def with_divider(variant: self.variant, **kwargs, &block)
        with_child(:divider, variant:, **kwargs, &block)
      end

      def with_header(*body, variant: self.variant, **kwargs, &block)
        with_child(:header, *body, variant:, **kwargs, &block)
      end
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
