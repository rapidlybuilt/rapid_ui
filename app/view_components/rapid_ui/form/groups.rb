module RapidUI
  module Form
    class Groups < ApplicationComponent
      attr_accessor :action
      attr_accessor :method

      renders_one :components, "Components"

      with_options to: :components do
        delegate :with_text_field_group
        delegate :with_email_field_group
        delegate :with_password_field_group
        delegate :with_select_field_group
        delegate :with_checkbox_field_group
        delegate :with_submit_group

        delegate :build_text_field_group
        delegate :build_email_field_group
        delegate :build_password_field_group
        delegate :build_select_field_group
        delegate :build_checkbox_field_group
        delegate :build_submit_group
      end

      def initialize(groups = [], action: nil, method: :post, **kwargs)
        super(tag_name: :form, **kwargs, class: merge_classes("grid grid-cols-12", kwargs[:class]))

        with_components(groups)

        @action = action
        @method = method

        yield self if block_given?
      end

      def component_tag_attributes
        attrs = super
        attrs[:action] = action if action
        attrs[:method] = method if method
        attrs
      end

      def call
        component_tag(render(components))
      end

      class Components < Components
        # Define builder methods for each field type
        contains :text_field_group, ->(name, placeholder: nil, value: nil, required: false, **kwargs, &block) do
          build(FieldGroup, name, **kwargs) do |field|
            field.build_input(
              id: field.field_id,
              name: field.field_name,
              type: "text",
              placeholder:,
              value:,
              required:,
            )
            block&.call(field)
          end
        end

        contains :email_field_group, ->(name, placeholder: nil, value: nil, required: false, **kwargs, &block) do
          build(FieldGroup, name, **kwargs) do |field|
            field.build_input(
              id: field.field_id,
              name: field.field_name,
              type: "email",
              placeholder:,
              value:,
              required:,
            )

            block&.call(field)
          end
        end

        contains :password_field_group, ->(name, placeholder: nil, value: nil, required: false, **kwargs, &block) do
          build(FieldGroup, name, **kwargs) do |field|
            field.with_input(
              id: field.field_id,
              name: field.field_name,
              type: "password",
              placeholder:,
              value:,
              required:,
            )
            block&.call(field)
          end
        end

        contains :select_field_group, ->(name, options = [], selected: nil, required: false, **kwargs, &block) do
          build(FieldGroup, name, **kwargs) do |field|
            field.input = build(
              SelectTag,
              id: field.field_id,
              name: field.field_name,
              options:,
              selected:,
              required:,
            )
            block&.call(field)
          end
        end

        contains :checkbox_field_group, ->(name, label_text: nil, checked: false, value: "1", col: 12, **kwargs, &block) do
          # Checkboxes are special - they wrap themselves in their own layout
          build(CheckboxFieldGroup, name, label_text:, checked:, value:, col: col, **kwargs, &block)
        end

        contains :submit_group, ->(label_text = "Submit", **kwargs, &block) do
          build(SubmitGroup, label_text, **kwargs, &block)
        end
      end
    end
  end
end
