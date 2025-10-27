module RapidUI
  module Fields
    class ButtonsGroup < ApplicationComponent
      include HasGridColumns

      attr_accessor :horizontal
      alias_method :horizontal?, :horizontal

      attr_accessor :colspan
      attr_accessor :label_colspan
      attr_accessor :content_colspan

      renders_many_polymorphic(:buttons,
        button: Button,
      )

      def initialize(colspans:, horizontal: false, **kwargs)
        super(tag_name: :div, **kwargs)

        @colspan = colspans[:group]
        @horizontal = horizontal

        if horizontal
          self.label_colspan = colspans[:label]
          self.content_colspan = colspans[:content]

          raise ArgumentError, "label and content colspans are required for horizontal forms" unless self.label_colspan && self.content_colspan
        end
      end

      def dynamic_css_class
        merge_classes(
          (horizontal? ? "#{grid_column_class(12)} grid grid-cols-12" : merge_classes(content_class, grid_column_class(colspan))),
          super,
        )
      end

      def call
        component_tag(group_tag_content)
      end

      def with_submit_button(*args, **kwargs, &block)
        with_button(*args, type: "submit", variant: "primary", **kwargs, &block)
      end

      def with_cancel_button(*args, **kwargs, &block)
        *body, path = *args # TODO: weird API?
        body = ["Cancel"] if body.empty? && !block

        with_button(*body, path:, variant: "secondary", **kwargs, &block)
      end

      private

      def content_class
        "field-buttons"
      end

      def group_tag_content
        content = safe_join(buttons)
        return content unless horizontal?

        safe_join([
          tag.div("", class: grid_column_class(label_colspan)),  # Empty spacer for label column
          tag.div(content, class: merge_classes(content_class, grid_column_class(content_colspan)))
        ])
      end
    end
  end
end
