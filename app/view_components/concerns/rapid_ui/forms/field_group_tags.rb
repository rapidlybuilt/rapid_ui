module RapidUI
  module Forms
    module FieldGroupTags
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

      def radio_button(value, disabled: false, label: nil, id: "#{field_id}_#{value}", **options)
        label ||= value.to_s.titleize unless label == false # TODO: label i18n

        tag.div(class: "field-radio-button") do
          html = radio_button_tag(value, id:, disabled:, **options)
          html << inline_label_tag(id, label, disabled:) if label.present?
          html
        end
      end

      def checkbox(name: self.name, label: nil, disabled: self.disabled?, id: field_id, **options)
        label ||= name.to_s.titleize unless label == false # TODO: label i18n

        tag.div(class: "field-checkbox") do
          html = checkbox_tag(name:, id:, disabled:, **options)
          html << inline_label_tag(id, label, disabled:) if label.present?
          html
        end
      end

      def select(choices = nil, id: field_id, name: self.name, selected: nil, include_blank: false, **options)
        if builder
          include_blank = "" if include_blank == true

          # select(method, choices = nil, options = {}, html_options = {}, &block)
          builder.select(
            name,
            choices,
            { selected:, include_blank: },
            **options,
            id:,
            class: content_field_class(options[:class]),
          )
        else
          choices.prepend("") if include_blank

          # select_tag(name, option_tags = nil, options = {})
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

      def inline_label_tag(id, label, disabled:)
        tag.label(label, for: id, class: merge_classes("field-label-inline", ("disabled" if disabled)))
      end
    end
  end
end
