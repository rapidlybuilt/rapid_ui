module RapidUI
  module Fields
    class Group < ApplicationComponent
      attr_accessor :name
      attr_accessor :col
      attr_accessor :field_id
      attr_accessor :check

      alias_method :check?, :check

      renders_one :label, ->(field_id, *args, **kwargs, &block) do
        build(
          Tag,
          *args,
          tag_name: :label,
          for: field_id,
          **kwargs,
          class: merge_classes(label_class, kwargs[:class]),
          &block
        )
      end

      def initialize(name, id:, check: false, field_id:, label_text: nil, col: 12, **kwargs)
        super(tag_name: :div, id:, **kwargs)

        @field_id = field_id
        @name = name
        @col = col
        @check = check # TODO: remove the need for this flag

        # TODO: I18n for default label text
        self.label = build_label(field_id, label_text || name.to_s.titleize)

        yield self if block_given?
      end

      def dynamic_css_class
        merge_classes(
          column_class,
          super,
        )
      end

      def call
        if check?
          components = [ content, label ]
        else
          components = [ label, content ]
        end

        component_tag do
          safe_join(components.map { |c| render(c) })
        end
      end

      def with_text_field(name = self.name, **kwargs)
        with_input_field("text", name, **kwargs)
      end

      def with_email_field(name = self.name, **kwargs)
        with_input_field("email", name, **kwargs)
      end

      def with_password_field(name = self.name, **kwargs)
        with_input_field("password", name, **kwargs)
      end

      def with_file_field(name = self.name, **kwargs)
        with_input_field("file", name, **kwargs)
      end

      def with_number_field(name = self.name, **kwargs)
        with_input_field("number", name, **kwargs)
      end

      def with_checkbox(name = self.name, **kwargs)
        with_input_field("checkbox", name, **kwargs)
      end

      def with_radio_button(name = self.name, **kwargs)
        with_input_field("radio", name, **kwargs) # TODO: implement a demo for this
      end

      def with_select(name = self.name, *args, **kwargs)
        # TODO: is this method really complex enough to warrant delegating to a view helper?
        with_content(
          build(
            ViewHelper,
            :select_tag,
            name,
            *args,
            **kwargs,
            class: merge_classes(content_class, kwargs[:class]),
          )
        )
      end

      def with_textarea(*args, **kwargs)
        # TODO implement this + a demo
      end

      private

      def label_class
        check? ? "form-check-label" : "form-label"
      end

      def content_class
        check? ? "form-check-input" : "form-control"
      end

      def column_class
        self.class.column_class(col)
      end

      def with_input_field(type = field_type, name, id: field_id, **kwargs)
        with_content(
          build(
            Tag,
            tag_name: :input,
            id:,
            name:,
            type:,
            **kwargs,
            class: merge_classes(content_class, kwargs[:class]),
          )
        )
      end

      class << self
        def column_class(col)
          # HACK: these are specified using a width parameter, so we need to explicitly declare the tailwind classes here.
          # tailwind include: col-span-1 col-span-2 col-span-3 col-span-4 col-span-5 col-span-6 col-span-7 col-span-8 col-span-9 col-span-10 col-span-11 col-span-12
          # tailwind include: sm:col-span-1 sm:col-span-2 sm:col-span-3 sm:col-span-4 sm:col-span-5 sm:col-span-6 sm:col-span-7 sm:col-span-8 sm:col-span-9 sm:col-span-10 sm:col-span-11 sm:col-span-12
          # tailwind include: md:col-span-1 md:col-span-2 md:col-span-3 md:col-span-4 md:col-span-5 md:col-span-6 md:col-span-7 md:col-span-8 md:col-span-9 md:col-span-10 md:col-span-11 md:col-span-12
          # tailwind include: lg:col-span-1 lg:col-span-2 lg:col-span-3 lg:col-span-4 lg:col-span-5 lg:col-span-6 lg:col-span-7 lg:col-span-8 lg:col-span-9 lg:col-span-10 lg:col-span-11 lg:col-span-12
          # tailwind include: xl:col-span-1 xl:col-span-2 xl:col-span-3 xl:col-span-4 xl:col-span-5 xl:col-span-6 xl:col-span-7 xl:col-span-8 xl:col-span-9 xl:col-span-10 xl:col-span-11 xl:col-span-12

          if col.is_a?(Hash)
            col.map { |breakpoint, size| "#{breakpoint}:col-span-#{size}" }.join(" ") + " col-span-12"
          elsif col == 12
            "col-span-12"
          else
            "col-span-12 md:col-span-#{col}"
          end
        end
      end
    end
  end
end
