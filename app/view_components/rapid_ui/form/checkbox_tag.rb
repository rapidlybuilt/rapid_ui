module RapidUI
  module Form
    class CheckboxTag < ApplicationComponent
      attr_accessor :name
      attr_accessor :label_text
      attr_accessor :checked
      attr_accessor :value
      attr_accessor :field_id
      attr_accessor :field_name

      alias_method :checked?, :checked

      def initialize(name:, label_text: nil, checked: false, value: "1", field_id: nil, field_name: nil, **kwargs)
        super(tag_name: nil, **kwargs)

        @name = name
        @label_text = label_text || name.to_s.titleize
        @checked = checked
        @value = value
        @field_id = field_id || name.to_s.parameterize.underscore
        @field_name = field_name || name.to_s

        yield self if block_given?
      end

      def call
        tag.div(class: "form-check") do
          safe_join([
            checkbox_tag,
            label_tag,
          ])
        end
      end

      private

      def checkbox_tag
        attrs = {
          type: "checkbox",
          class: "form-check-input",
          id: field_id,
          name: field_name,
          value: value,
        }
        attrs[:checked] = true if checked?

        tag.input(**attrs)
      end

      def label_tag
        tag.label(label_text, for: field_id, class: "form-check-label")
      end
    end
  end
end
