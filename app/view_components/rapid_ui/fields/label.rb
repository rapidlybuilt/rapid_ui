module RapidUI
  module Fields
    class Label < ApplicationComponent
      include HasGridColumns

      attr_accessor :text
      attr_accessor :field_id
      attr_accessor :check
      attr_accessor :horizontal
      attr_accessor :colspan

      alias_method :check?, :check
      alias_method :horizontal?, :horizontal

      def initialize(text, field_id:, check: false, horizontal: false, colspan: nil, **kwargs)
        raise ArgumentError, "colspan is required for horizontal forms" if horizontal && colspan.nil?

        super(tag_name: :label, **kwargs)

        @text = text
        @field_id = field_id
        @check = check
        @horizontal = horizontal
        @colspan = colspan
      end

      def dynamic_css_class
        merge_classes(super, dynamic_label_class)
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
        if check? && horizontal?
          "field-check-label"
        elsif horizontal?
          merge_classes("col-field-label", grid_column_class(colspan))
        elsif check?
          "field-check-label"
          else
          "field-label"
        end
      end
    end
  end
end
