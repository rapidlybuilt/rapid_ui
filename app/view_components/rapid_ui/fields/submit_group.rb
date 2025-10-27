module RapidUI
  module Fields
    class SubmitGroup < ApplicationComponent
      include HasColumnClass

      attr_accessor :label_text
      attr_accessor :variant

      def initialize(label_text = "Submit", variant: "primary", col: 12, **kwargs)
        super(tag_name: :div, **kwargs)

        @label_text = label_text
        @variant = variant
        self.col = col
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

      def button_class
        merge_classes(
          "btn",
          ("btn-#{variant}" if variant),
        )
      end
    end
  end
end
