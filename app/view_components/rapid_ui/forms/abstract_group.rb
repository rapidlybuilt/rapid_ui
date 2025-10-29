module RapidUI
  module Forms
    class AbstractGroup < ApplicationComponent
      include HasGridColumns

      attr_accessor :inline
      attr_accessor :horizontal

      attr_accessor :colspan
      attr_accessor :label_colspan
      attr_accessor :content_colspan

      alias_method :inline?, :inline
      alias_method :horizontal?, :horizontal

      def initialize(id: nil, inline: false, colspans:, horizontal: false, **kwargs)
        super(tag_name: :div, id:, **kwargs)

        @colspan = colspans[:group]

        @inline = inline
        @horizontal = horizontal

        if horizontal
          self.label_colspan = colspans[:label]
          self.content_colspan = colspans[:content]

          raise ArgumentError, "label and content colspans are required for horizontal forms" unless self.label_colspan && self.content_colspan
        end
      end

      def dynamic_css_class
        merge_classes(
          (horizontal? ? horizontal_css_class : vertical_css_class),
          super,
        )
      end

      def call
        component_tag(group_tag_content)
      end

      private

      def horizontal_css_class
        "#{grid_column_class(12)} grid grid-cols-12"
      end

      def vertical_css_class
        grid_column_class(colspan)
      end

      def group_tag_content
        raise NotImplementedError, "subclasses must implement #group_tag_content"
      end

      def content_field_class
        inline? ? "field-control-inline" : "field-control"
      end
    end
  end
end
