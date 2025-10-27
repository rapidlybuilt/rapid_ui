module RapidUI
  module Forms
    class RadioButtonGroup < AbstractGroup
      attr_accessor :name
      attr_accessor :field_id

      # TODO: I18n for default label text
      renders_one :label, ->(text = name.to_s.titleize, **kwargs) do
        build(
          Label,
          text,
          field_id:,
          check: false,
          horizontal:,
          colspan: label_colspan,
          **kwargs,
        )
      end

      renders_many_polymorphic(:options,
        option: ->(value, checked, *label_args, **kwargs) {
          build(Option, name, value, checked, *label_args, **kwargs)
        },
      )

      def initialize(name, id:, **kwargs)
        super(id:, check: true, **kwargs)
        @name = name
      end

      private

      def before_render
        with_label if !label? && horizontal?
        super
      end

      def group_tag_content
        if horizontal?
          safe_join([
            label,
            tag.div(safe_join(options), class: grid_column_class(content_colspan)),
          ])
        else
          tag.div(class: "field-buttons") do
            safe_join(options)
          end
        end
      end

      class Option < ApplicationComponent
        # TODO: disabled option

        attr_accessor :name
        attr_accessor :value
        attr_accessor :checked
        attr_accessor :label
        attr_accessor :disabled

        alias_method :disabled?, :disabled

        def initialize(name, value, checked, label_text = nil, disabled: false, **kwargs)
          super(tag_name: :label, **kwargs, class: merge_classes("field-label", kwargs[:class]))

          @name = name
          @value = value
          @checked = checked
          @label = label_text || value.to_s.titleize # TODO: I18n
          @disabled = disabled
        end

        def dynamic_css_class
          merge_classes(super, ("disabled" if disabled?))
        end

        def call
          body = content || radio_button_tag(name, value, checked, disabled:)

          component_tag class: "mt-2" do
            safe_join([ body, tag.span(label, class: "field-check-label") ])
          end
        end
      end
    end
  end
end
