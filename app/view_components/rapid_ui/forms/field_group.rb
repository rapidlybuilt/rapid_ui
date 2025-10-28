module RapidUI
  module Forms
    class FieldGroup < AbstractGroup
      include FieldGroupTags

      attr_accessor :name
      attr_accessor :field_id
      attr_accessor :builder
      attr_accessor :disabled
      alias_method :disabled?, :disabled

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
          disabled: disabled?,
          **kwargs,
        )
      end

      attr_accessor :builder
      def initialize(name, id:, type: false, field_id:, colspans:, horizontal: false, error: nil, hint: nil, builder: nil, disabled: false, **kwargs)
        @type = type

        super(tag_name: :div, id:, inline: inline?, colspans:, horizontal:, **kwargs)

        @field_id = field_id
        @name = name
        @builder = builder
        @disabled = disabled

        with_error(error) if error.present?
        with_hint(hint) if hint.present?
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
        with_label unless label? || inline?
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
    end
  end
end
