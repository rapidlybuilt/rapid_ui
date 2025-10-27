module RapidUI
  module Fields
    class Group < ApplicationComponent
      include HasGridColumns

      attr_accessor :name
      attr_accessor :field_id
      attr_accessor :check
      attr_accessor :horizontal

      attr_accessor :colspan
      attr_accessor :label_colspan
      attr_accessor :content_colspan

      alias_method :check?, :check
      alias_method :horizontal?, :horizontal

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
        super(tag_name: :div, id:, **kwargs)

        @colspan = colspans[:group]

        @field_id = field_id
        @name = name
        @check = check # TODO: remove the need for this flag
        @horizontal = horizontal

        if horizontal
          self.label_colspan = colspans[:label]
          self.content_colspan = colspans[:content]

          raise ArgumentError, "label and content colspans are required for horizontal forms" unless self.label_colspan && self.content_colspan
        end
      end

      def dynamic_css_class
        merge_classes(
          (horizontal? ? "#{grid_column_class(12)} grid grid-cols-12" : grid_column_class(colspan)),
          super,
        )
      end

      # TODO: support self.label.with_content("Foo")
      # which doesn't currently work because it keeps the content from being set from the block.

      def call
        component_tag(group_tag_content)
      end

      # Add our ID, name and class attributes to Rails' field_tag helpers
      %i[
        text_field_tag password_field_tag email_field_tag checkbox_tag
        textarea_tag radio_button_tag number_field_tag file_field_tag hidden_field_tag
        search_field_tag tel_field_tag url_field_tag time_field_tag datetime_field_tag
      ].each do |helper_name|
        define_method(helper_name) do |value = nil, **options|
          view_helper_field_tag(helper_name, value, **options)
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
            tag.div(safe_join([content, label]), class: grid_column_class(content_colspan))
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

      def content_field_class
        check? ? "field-check-input" : "field-control"
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
