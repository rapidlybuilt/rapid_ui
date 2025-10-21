module RapidUI
  module Form
    class FieldGroup < ApplicationComponent
      attr_accessor :name
      attr_accessor :label_text
      attr_accessor :col

      renders_one :input, ->(*args, **kwargs, &block) do
        build(
          Tag,
          *args,
          tag_name: :input,
          **kwargs,
          class: merge_classes("form-control", kwargs[:class]),
          &block
        )
      end

      def initialize(name, label_text: nil, col: 12, **kwargs)
        super(tag_name: :div, **kwargs)

        @name = name
        @label_text = label_text || name.to_s.titleize
        @col = col

        yield self if block_given?
      end

      def dynamic_css_class
        merge_classes(
          column_class,
          super,
        )
      end

      def call
        component_tag do
          safe_join([
            label_tag,
            input,
          ])
        end
      end

      def field_id
        name.to_s.parameterize.underscore
      end

      def field_name
        name.to_s
      end

      private

      def column_class
        FieldGroup.column_class(col)
      end

      def label_tag
        tag.label(label_text, for: field_id, class: "form-label")
      end

      class << self
        def column_class(size_col)
          # HACK: these are specified using a width parameter, so we need to explicitly declare the tailwind classes here.
          # tailwind include: col-span-1 col-span-2 col-span-3 col-span-4 col-span-5 col-span-6 col-span-7 col-span-8 col-span-9 col-span-10 col-span-11 col-span-12
          # tailwind include: sm:col-span-1 sm:col-span-2 sm:col-span-3 sm:col-span-4 sm:col-span-5 sm:col-span-6 sm:col-span-7 sm:col-span-8 sm:col-span-9 sm:col-span-10 sm:col-span-11 sm:col-span-12
          # tailwind include: md:col-span-1 md:col-span-2 md:col-span-3 md:col-span-4 md:col-span-5 md:col-span-6 md:col-span-7 md:col-span-8 md:col-span-9 md:col-span-10 md:col-span-11 md:col-span-12
          # tailwind include: lg:col-span-1 lg:col-span-2 lg:col-span-3 lg:col-span-4 lg:col-span-5 lg:col-span-6 lg:col-span-7 lg:col-span-8 lg:col-span-9 lg:col-span-10 lg:col-span-11 lg:col-span-12
          # tailwind include: xl:col-span-1 xl:col-span-2 xl:col-span-3 xl:col-span-4 xl:col-span-5 xl:col-span-6 xl:col-span-7 xl:col-span-8 xl:col-span-9 xl:col-span-10 xl:col-span-11 xl:col-span-12

          if size_col.is_a?(Hash)
            size_col.map { |breakpoint, size| "#{breakpoint}:col-span-#{size}" }.join(" ") + " col-span-12"
          elsif size_col == 12
            "col-span-12"
          else
            "col-span-12 md:col-span-#{size_col}"
          end
        end
      end
    end
  end
end
