module RapidUI
  module Forms
    class FieldGroup < AbstractGroup
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

      # Add our ID, name and class attributes to Rails' field_tag helpers
      %i[
        text_field password_field email_field
        textarea radio_button number_field file_field hidden_field
        search_field telephone_field url_field time_field datetime_field
      ].each do |helper_name|
        define_method(helper_name) do |*args, **options|
          field_tag(helper_name, *args, **options)
        end
      end

      def radio_button(value, disabled: false, label: nil, **options)
        # TODO: i18n

        tag.div do
          id = "#{field_id}_#{value}"
          html = radio_button_tag(value, id:, disabled:, **options)
          html << tag.label(label, for: id, class: merge_classes("field-label-inline", ("disabled" if disabled))) if label.present?
          html
        end
      end

      def checkbox(name: self.name, label: nil, disabled: self.disabled?, id: field_id, **options)
        label ||= name.to_s.titleize unless label == false # TODO: i18n

        tag.div do
          html = checkbox_tag(name:, id:, disabled:, **options)
          html << tag.label(label, for: id, class: merge_classes("field-label-inline", ("disabled" if disabled))) if label.present?
          html
        end
      end

      def select(choices = nil, id: field_id, name: self.name, selected: nil, include_blank: false, **options)
        if builder
          # select(method, choices = nil, options = {}, html_options = {}, &block)
          builder.select(
            name,
            choices,
            { selected:, include_blank: (include_blank == true ? "" : include_blank)},
            **options,
            id:,
            class: content_field_class(options[:class]),
          )
        else
          # select_tag(name, option_tags = nil, options = {})
          choices.prepend(choices.first.is_a?(Array) ? [ "", "" ] : "") if include_blank
          view_context.select_tag(
            name,
            options_for_select(choices, selected),
            **options,
            id:,
            class: content_field_class(options[:class]),
          )
        end
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

      def field_tag(helper_name, **options)
        if builder
          builder_field_tag(helper_name, **options)
        else
          view_helper_field_tag(:"#{helper_name}_tag", **options)
        end
      end

      def builder_field_tag(helper_name, *args, name: self.name, disabled: self.disabled?, **options)
        builder.send(
          helper_name,
          name,
          *args,
          disabled:,
          **options,
          class: content_field_class(options[:class]),
        )
      end

      # content will come from a Rails field_tag helper method
      def view_helper_field_tag(helper_name, *args, name: self.name, value: nil, id: field_id, disabled: self.disabled?, **options)
        view_context.send(
          helper_name,
          name,
          value,
          *args,
          id:,
          disabled:,
          **options,
          class: content_field_class(options[:class]),
        )
      end

      def radio_button_tag(value, name: self.name, checked: nil, disabled: self.disabled?, **options)
        if builder
          # radio_button(method, tag_value, options = {})
          builder.radio_button(name, value, checked:, disabled:, **options, class: content_field_class(options[:class]))
        else
          # radio_button_tag(name, value, checked, options = {})
          view_context.radio_button_tag(name, value, checked, disabled:, **options, class: content_field_class(options[:class]))
        end
      end

      def checkbox_tag(name: self.name, checked: nil, disabled: self.disabled?, value: "1", unchecked_value: "0", **options)
        if builder
          # checkbox(method, options = {}, checked_value = "1", unchecked_value = "0")
          builder.checkbox(name, options.merge(checked:, disabled:, class: content_field_class(options[:class])), value, unchecked_value)
        else
          # checkbox_tag(name, value, checked, options = {})
          view_context.checkbox_tag(name, value, checked, disabled:, **options, class: content_field_class(options[:class]))
        end
      end

      def content_field_class(css = nil)
        merge_classes(super(), ("field-control-error" if error?), css)
      end
    end
  end
end
