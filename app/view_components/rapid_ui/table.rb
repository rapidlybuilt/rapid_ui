module RapidUI
  class Table < ApplicationComponent
    attr_accessor :striped
    attr_accessor :hover
    attr_accessor :bordered
    attr_accessor :borderless
    attr_accessor :small
    attr_accessor :align
    attr_accessor :responsive

    alias_method :striped?, :striped
    alias_method :hover?, :hover
    alias_method :bordered?, :bordered
    alias_method :borderless?, :borderless
    alias_method :small?, :small
    alias_method :responsive?, :responsive

    renders_one :caption, ->(*args, **kwargs, &block) do
      build(Caption, *args, **kwargs, &block)
    end

    renders_one :head, ->(*args, **kwargs, &block) do
      build(Rows, *args, tag_name: :thead, cell_attributes: { tag_name: :th, scope: "col" }, **kwargs, &block)
    end

    renders_one :body, ->(*args, **kwargs, &block) do
      build(Rows, *args, tag_name: :tbody, **kwargs, &block)
    end

    renders_one :foot, ->(*args, **kwargs, &block) do
      build(Rows, *args, tag_name: :tfoot, **kwargs, &block)
    end

    def initialize(
      striped: false,
      hover: false,
      bordered: false,
      borderless: false,
      small: false,
      align: nil,
      responsive: false,
      **kwargs
    )
      super(tag_name: :table, **kwargs)

      @striped = striped
      @hover = hover
      @bordered = bordered
      @borderless = borderless
      @small = small
      @align = align
      @responsive = responsive

      yield self if block_given?
    end

    def dynamic_css_class
      merge_classes(
        "table",
        ("table-striped" if striped?),
        ("table-hover" if hover?),
        ("table-bordered" if bordered?),
        ("table-borderless" if borderless?),
        ("table-sm" if small?),
        ("table-align-#{align}" if align),
        super,
      )
    end

    def call
      table = component_tag do
        [ caption, head, body, foot ].compact.map { |part| render(part) }.join.html_safe
      end

      if responsive?
        tag.div(table, class: responsive_class)
      else
        table
      end
    end

    private

    def responsive_class
      case responsive
      when true, "always"
        "table-responsive"
      when String
        "table-responsive-#{responsive}"
      else
        "table-responsive"
      end
    end

    class Caption < ApplicationComponent
      attr_accessor :position

      def initialize(*children, position: :top, **kwargs)
        super(tag_name: :caption, **kwargs)

        with_content(safe_components(*children)) if children.any?

        @position = position

        yield self if block_given?
      end

      def dynamic_css_class
        merge_classes(
          ("caption-bottom" if position == :bottom),
          super,
        )
      end

      def call
        component_tag(render(content))
      end
    end

    class Rows < Components
      attr_accessor :cell_attributes

      # TODO: way to specify all cells (as text) when building a row
      contains :row, ->(*args, **kwargs, &block) do
        build(Row, *args, cell_attributes:, **kwargs, &block)
      end

      def initialize(rows = [], cell_attributes: { tag_name: :td }, **kwargs)
        super(rows, **kwargs, &nil)

        @cell_attributes = cell_attributes

        yield self if block_given?
      end
    end

    class Row < Components
      attr_accessor :variant
      attr_accessor :active
      attr_accessor :cell_attributes

      alias_method :active?, :active

      contains :cell, ->(*args, **kwargs, &block) do
        build(Cell, *args, **cell_attributes, **kwargs, &block)
      end

      def initialize(cells = [], variant: nil, active: false, cell_attributes: {}, **kwargs)
        super(cells, tag_name: :tr, **kwargs, &nil)

        @variant = variant
        @active = active
        @cell_attributes = cell_attributes

        yield self if block_given?
      end

      def dynamic_css_class
        merge_classes(
          ("table-#{variant}" if variant),
          ("table-active" if active?),
          super,
        )
      end
    end

    class Cell < ApplicationComponent
      attr_accessor :header
      attr_accessor :scope

      alias_method :header?, :header

      def initialize(*children, header: false, scope: nil, **kwargs)
        super(tag_name: (header ? :th : :td), **kwargs)

        with_content(safe_components(*children)) if children.any?

        @header = header
        @scope = scope

        yield self if block_given?
      end

      def call
        attrs = {}
        attrs[:scope] = scope if scope
        component_tag(render(content), **attrs)
      end
    end

    class << self
      def variants
        [
          "light-primary",
          "light-secondary",
          "dark-primary",
          "dark-secondary",
          "success",
          "danger",
          "warning",
          "info",
        ]
      end
    end
  end
end
