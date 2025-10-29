module RapidUI
  module Forms
    class Label < ApplicationComponent
      include HasGridColumns

      attr_accessor :text
      attr_accessor :field_id
      attr_accessor :inline
      attr_accessor :horizontal
      attr_accessor :colspan
      attr_accessor :error
      attr_accessor :disabled

      alias_method :inline?, :inline
      alias_method :horizontal?, :horizontal
      alias_method :error?, :error
      alias_method :disabled?, :disabled

      def initialize(text, field_id:, inline: false, horizontal: false, colspan: nil, error: false, disabled: false, **kwargs)
        raise ArgumentError, "colspan is required for horizontal forms" if horizontal && colspan.nil?

        super(tag_name: :label, **kwargs)

        @text = text
        @field_id = field_id
        @inline = inline
        @horizontal = horizontal
        @colspan = colspan
        @error = error
        @disabled = disabled
      end

      def dynamic_css_class
        merge_classes(
          super,
          dynamic_label_class,
          error_label_class,
          ("disabled" if disabled?),
        )
      end

      def component_tag_attributes
        super.merge(for: field_id)
      end

      def call
        component_tag(content)
      end

      private

      def before_render
        with_content(text) unless content?
        super
      end

      def dynamic_label_class
        if inline?
          "field-label-inline"
        elsif horizontal?
          merge_classes("col-field-label", grid_column_class(colspan))
        else
          "field-label"
        end
      end

      def error_label_class
        "text-danger" if error?
      end
    end
  end
end
