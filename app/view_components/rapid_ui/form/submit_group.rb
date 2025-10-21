module RapidUI
  module Form
    class SubmitGroup < ApplicationComponent
      attr_accessor :label_text
      attr_accessor :variant
      attr_accessor :size_col

      def initialize(label_text = "Submit", variant: "primary", size: 12, **kwargs)
        super(tag_name: :div, **kwargs)

        @label_text = label_text
        @variant = variant
        @size_col = size

        yield self if block_given?
      end

      def dynamic_css_class
        merge_classes(
          column_class,
          super,
        )
      end

      def call
        component_tag do
          tag.button(label_text, type: "submit", class: button_class)
        end
      end

      private

      def column_class
        FieldGroup.column_class(size_col)
      end

      def button_class
        merge_classes(
          "btn",
          ("btn-#{variant}" if variant),
        )
      end
    end
  end
end
