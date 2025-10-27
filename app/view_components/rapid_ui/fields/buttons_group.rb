module RapidUI
  module Fields
    class ButtonsGroup < ApplicationComponent
      include HasColumnClass

      attr_accessor :label_col
      attr_accessor :horizontal
      alias_method :horizontal?, :horizontal

      renders_many_polymorphic(:buttons,
        button: Button,
      )

      def initialize(col: 12, horizontal: false, label_col: nil, **kwargs)
        raise ArgumentError, "label_col is required for horizontal forms" if horizontal && label_col.nil?

        super(tag_name: :div, **kwargs)

        self.col = col
        @horizontal = horizontal
        @label_col = label_col
      end

      def dynamic_css_class
        merge_classes(
          (horizontal? ? "#{column_class(12)} grid grid-cols-12" : merge_classes(content_class, column_class)),
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
          tag.div("", class: column_class(label_col)),  # Empty spacer for label column
          tag.div(content, class: merge_classes(content_class, horizontal_content_class))
        ])
      end

      def horizontal_content_class
        # For horizontal checkbox, add offset to align with other fields
        content_col = self.col - self.label_col

        column_class(content_col)
      end
    end
  end
end
