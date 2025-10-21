module RapidUI
  module Form
    # Checkbox field group - handles column layout for checkboxes
    class CheckboxFieldGroup < ApplicationComponent
      attr_accessor :name
      attr_accessor :label_text
      attr_accessor :col
      attr_accessor :checked
      attr_accessor :value

      renders_one :input, ->(*args, **kwargs, &block) do
        build(CheckboxTag, *args, **kwargs, &block)
      end

      def initialize(name, label_text: nil, col: 12, checked: false, value: "1", **kwargs)
        super(tag_name: :div, **kwargs)

        with_input(
          name:,
          label_text:,
          checked:,
          value:,
          factory:,
        )

        @name = name
        @label_text = label_text
        @col = col
        @checked = checked
        @value = value

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
          render(input)
        end
      end

      private

      def column_class
        FieldGroup.column_class(col)
      end
    end
  end
end
