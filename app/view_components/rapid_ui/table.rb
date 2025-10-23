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

    renders_one :caption, "Caption"

    renders_one :head, ->(**kwargs) do
      build(RowsContainer, tag_name: :thead, cell_attributes: { tag_name: :th, scope: "col" }, **kwargs)
    end

    renders_one :body, ->(**kwargs) do
      build(RowsContainer, tag_name: :tbody, **kwargs)
    end

    renders_one :foot, ->(**kwargs) do
      build(RowsContainer, tag_name: :tfoot, **kwargs)
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
        safe_join([ caption, head, body, foot ])
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
      include HasBodyContent

      attr_accessor :position

      def initialize(*body, position: :top, **kwargs)
        super(tag_name: :caption, **kwargs)

        self.body = body

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
        component_tag(content)
      end
    end

    class RowsContainer < ApplicationComponent
      attr_accessor :cell_attributes

      renders_many :rows, ->(**kwargs) do
        build(Row, cell_attributes:, **kwargs)
      end

      def initialize(cell_attributes: { tag_name: :td }, **kwargs)
        super(**kwargs, &nil)

        @cell_attributes = cell_attributes

        yield self if block_given?
      end

      def call
        component_tag { safe_join(rows) }
      end
    end

    class Row < ApplicationComponent
      attr_accessor :variant
      attr_accessor :active
      attr_accessor :cell_attributes

      alias_method :active?, :active

      renders_many :cells, ->(*body, **kwargs, &block) do
        build(Cell, *body, **cell_attributes, **kwargs)
      end

      def initialize(variant: nil, active: false, cell_attributes: {}, **kwargs)
        super(tag_name: :tr, **kwargs, &nil)

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

      def call
        component_tag { safe_join(cells) }
      end
    end

    class Cell < ApplicationComponent
      include HasBodyContent

      attr_accessor :header
      attr_accessor :scope

      alias_method :header?, :header

      def initialize(*body, header: false, scope: nil, **kwargs)
        super(tag_name: (header ? :th : :td), **kwargs)

        self.body = body

        @header = header
        @scope = scope

        yield self if block_given?
      end

      def component_tag_attributes
        attrs = super
        attrs[:scope] = scope if scope
        attrs
      end

      def call
        component_tag(content)
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
