module RapidUI
  module Fields
    class Label < ApplicationComponent
      include HasColumnClass

      attr_accessor :text
      attr_accessor :field_id
      attr_accessor :check
      attr_accessor :horizontal

      alias_method :check?, :check
      alias_method :horizontal?, :horizontal

      def initialize(text, field_id:, check: false, horizontal: false, col: nil, **kwargs)
        raise ArgumentError, "col is required for horizontal forms" if horizontal && col.nil?

        super(tag_name: :label, **kwargs)

        with_content(safe_components(text)) if text
        @field_id = field_id
        @check = check
        @horizontal = horizontal

        self.col = col
      end

      def dynamic_css_class
        merge_classes(super, dynamic_label_class)
      end

      def component_tag_attributes
        super.merge(for: field_id)
      end

      def call
        component_tag(render(content))
      end

      private

      def dynamic_label_class
        if check?
          "form-check-label"
        elsif horizontal?
          merge_classes("col-form-label", column_class)
        else
          "form-label"
        end
      end
    end
  end
end
