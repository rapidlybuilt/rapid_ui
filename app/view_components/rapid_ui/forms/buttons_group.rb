module RapidUI
  module Forms
    class ButtonsGroup < AbstractGroup
      renders_many_polymorphic(:buttons,
        button: Button,
      )

      def initialize(colspans:, horizontal: false, **kwargs)
        super(tag_name: :div, colspans:, horizontal:, check: true, **kwargs)
      end

      def with_submit_button(*args, **kwargs, &block)
        with_button(*args, type: "submit", variant: "primary", **kwargs, &block)
      end

      def with_link(*args, **kwargs, &block)
        *body, path = *args # TODO: weird API?

        with_button(*body, path:, variant: "secondary", **kwargs, &block)
      end

      def with_cancel_link(*args, **kwargs, &block)
        *body, path = *args # TODO: weird API?
        body = [ "Cancel" ] if body.empty? && !block

        with_link(*body, path, variant: "secondary", **kwargs, &block)
      end

      private

      def vertical_css_class
        merge_classes(content_class, grid_column_class(colspan))
      end

      def content_class
        "field-buttons"
      end

      def group_tag_content
        content = safe_join(buttons)
        return content unless horizontal?

        safe_join([
          tag.div("", class: grid_column_class(label_colspan)),  # Empty spacer for label column
          tag.div(content, class: merge_classes(content_class, grid_column_class(content_colspan))),
        ])
      end
    end
  end
end
