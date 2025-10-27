module RapidUI
  module Forms
    class FieldGroup < AbstractGroup
      attr_accessor :name
      attr_accessor :field_id

      # TODO: I18n for default label text
      renders_one :label, ->(text = name.to_s.titleize, **kwargs) do
        build(
          Label,
          text,
          field_id:,
          check:,
          horizontal:,
          colspan: label_colspan,
          **kwargs,
        )
      end

      def initialize(name, id:, check: false, field_id:, colspans:, horizontal: false, **kwargs)
        super(tag_name: :div, id:, check:, colspans:, horizontal:, **kwargs)

        @field_id = field_id
        @name = name
      end

      # Add our ID, name and class attributes to Rails' field_tag helpers
      %i[
        text_field_tag password_field_tag email_field_tag checkbox_tag
        textarea_tag radio_button_tag number_field_tag file_field_tag hidden_field_tag
        search_field_tag tel_field_tag url_field_tag time_field_tag datetime_field_tag
      ].each do |helper_name|
        define_method(helper_name) do |value = nil, *args, **options|
          view_helper_field_tag(helper_name, value, *args, **options)
        end
      end

      def select_tag(option_tags = nil, **options)
        view_helper_field_tag(:select_tag, option_tags, **options)
      end

      private

      def before_render
        with_label unless label?
        super
      end

      def group_tag_content
        if horizontal? && check?
          safe_join([
            tag.div("", class: grid_column_class(label_colspan)),  # Empty spacer for label column
            tag.div(safe_join([ content, label ]), class: grid_column_class(content_colspan)),
          ])
        elsif horizontal?
          safe_join([
            label,
            tag.div(content, class: grid_column_class(content_colspan)),
          ])
        elsif check?
          safe_join([ content, label ])
        else
          safe_join([ label, content ])
        end
      end

      # content will come from a Rails field_tag helper method
      def view_helper_field_tag(helper_name, *args, id: field_id, **options)
        view_context.send(
          helper_name,
          self.name,
          *args,
          id:,
          **options,
          class: merge_classes(content_field_class, options[:class]),
        )
      end
    end
  end
end
