module RapidUI
  module Fields
    class Group < ApplicationComponent
      include HasColumnClass

      attr_accessor :name
      attr_accessor :field_id
      attr_accessor :check
      attr_accessor :horizontal
      attr_accessor :label_col

      alias_method :check?, :check
      alias_method :horizontal?, :horizontal

      # TODO: I18n for default label text
      renders_one :label, ->(text = name.to_s.titleize, **kwargs, &block) do
        build(
          Label,
          text,
          field_id:,
          check:,
          horizontal:,
          col: label_col,
          **kwargs,
          &block
        )
      end

      def initialize(name, id:, check: false, field_id:, col: 12, horizontal: false, label_col: nil, **kwargs)
        raise ArgumentError, "label_col is required for horizontal forms" if horizontal && label_col.nil?

        super(tag_name: :div, id:, **kwargs)

        self.col = col

        @field_id = field_id
        @name = name
        @check = check # TODO: remove the need for this flag
        @horizontal = horizontal
        @label_col = label_col

        # TODO: I18n for default label text
        self.label = build_label

        yield self if block_given?
      end

      def dynamic_css_class
        merge_classes(
          column_class,
          ("grid grid-cols-#{col}" if horizontal?),
          super,
        )
      end

      # TODO: support self.label.with_content("Foo")
      # which doesn't currently work because it keeps the content from being set from the block.

      def call
        label = render(self.label)

        component_tag do
          if check?
            safe_join([ content, label ])
          elsif horizontal?
            # TODO: col may be a responsive hash
            content_col = self.col - self.label.col
            safe_join([
              label,
              tag.div(content, class: merge_classes(column_class(content_col))),
            ])
          else
            safe_join([ label, content ])
          end
        end
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

      def content_class
        check? ? "form-check-input" : "form-control"
      end

      # content will come from a Rails field_tag helper method
      def view_helper_field_tag(helper_name, *args, id: field_id, **options)
        with_content do
          view_context.send(
            helper_name,
            self.name,
            *args,
            id:,
            **options,
            class: merge_classes(content_class, options[:class]),
          )
        end
      end
    end
  end
end
