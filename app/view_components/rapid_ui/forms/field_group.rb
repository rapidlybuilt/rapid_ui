module RapidUI
  module Forms
    class FieldGroup < AbstractGroup
      attr_accessor :name
      attr_accessor :field_id

      renders_one :hint, ->(*args, **kwargs) do
        build(
          Tag,
          *args,
          tag_name: :div,
          **kwargs,
          class: merge_classes("field-hint", kwargs[:class]),
        )
      end

      renders_one :error, ->(*args, **kwargs) do
        build(
          Tag,
          *args,
          tag_name: :div,
          **kwargs,
          class: merge_classes("field-error", kwargs[:class]),
        )
      end

      # TODO: I18n for default label text
      renders_one :label, ->(text = name.to_s.titleize, **kwargs) do
        build(
          Label,
          text,
          field_id:,
          inline:,
          horizontal:,
          colspan: label_colspan,
          error: error?,
          **kwargs,
        )
      end

      def initialize(name, id:, type: false, field_id:, colspans:, horizontal: false, error: nil, hint: nil, **kwargs)
        @type = type

        super(tag_name: :div, id:, inline: inline?, colspans:, horizontal:, **kwargs)

        @field_id = field_id
        @name = name

        with_error(error) if error.present?
        with_hint(hint) if hint.present?
      end

      # Add our ID, name and class attributes to Rails' field_tag helpers
      %i[
        text_field_tag password_field_tag email_field_tag checkbox_tag
        textarea_tag radio_button_tag number_field_tag file_field_tag hidden_field_tag
        search_field_tag telephone_field_tag url_field_tag time_field_tag datetime_field_tag
      ].each do |helper_name|
        define_method(helper_name) do |value = nil, *args, **options|
          view_helper_field_tag(helper_name, value, *args, **options)
        end
      end

      def radio_button_tag(value, checked = false, label: nil, **options)
        tag.div do
          id = "#{field_id}_#{value}"
          html = view_helper_field_tag(:radio_button_tag, value, checked, id:, **options)
          html << tag.label(label, for: id, class: "field-label-inline") if label.present?
          html
        end
      end

      def select_tag(option_tags = nil, **options)
        view_helper_field_tag(:select_tag, option_tags, **options)
      end

      private

      def dynamic_css_class
        merge_classes(
          super,
          ("field-buttons" if radio?),
        )
      end

      def inline?
        checkbox? || radio?
      end

      def radio?
        @type == :radio
      end

      def checkbox?
        @type == :checkbox
      end

      def before_render
        with_label unless label? || radio?
        super
      end

      def group_tag_content
        if horizontal? && inline?
          safe_join([
            tag.div("", class: grid_column_class(label_colspan)),  # Empty spacer for label column
            tag.div(safe_join([ content, label, error_message, hint_message ].compact), class: grid_column_class(content_colspan)),
          ])
        elsif horizontal?
          safe_join([
            tag.div(label, class: merge_classes(grid_column_class(label_colspan))),
            tag.div(safe_join([ content, error_message, hint_message ].compact), class: grid_column_class(content_colspan)),
          ])
        elsif checkbox?
          safe_join([ content, label, error_message, hint_message ].compact)
        else
          safe_join([ label, content, error_message, hint_message ].compact)
        end
      end

      def error_message
        return nil unless error?

        tag.div(error, class: "field-error text-danger")
      end

      def hint_message
        return nil unless hint?

        tag.div(hint, class: "field-hint")
      end

      # content will come from a Rails field_tag helper method
      def view_helper_field_tag(helper_name, *args, id: field_id, **options)
        view_context.send(
          helper_name,
          self.name,
          *args,
          id:,
          **options,
          class: merge_classes(content_field_class, error_field_class, options[:class]),
        )
      end

      def error_field_class
        "field-control-error" if error?
      end
    end
  end
end
