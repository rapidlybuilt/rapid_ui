module RapidUI
  module Forms
    module GroupsTags
      %i[
        text_field password_field email_field
        textarea number_field file_field hidden_field
        search_field telephone_field url_field time_field datetime_field
      ].each do |helper_name|
        define_method(:"#{helper_name}_group") do |name, placeholder: nil, value: nil, **options|
          render new_group(name, **options) do |g|
            g.send(helper_name, placeholder:, value:)
          end
        end

        define_method(:"with_#{helper_name}_group") do |name, placeholder: nil, value: nil, **options|
          with_group(name, **options) do |g|
            g.send(:"#{helper_name}", placeholder:, value:)
          end
        end
      end

      def checkbox_group(*args, **kwargs, &block)
        block ||= ->(g) { g.checkbox }
        render new_group(*args, type: :checkbox, **kwargs), &block
      end

      def with_checkbox_group(name, **kwargs, &block)
        block ||= ->(g) { g.checkbox }
        with_group(name, type: :checkbox, **kwargs, &block)
      end

      def radio_button_group(*args, **kwargs, &block)
        render new_group(*args, type: :radio, **kwargs), &block
      end

      def with_radio_button_group(name, **kwargs, &block)
        with_group(name, type: :radio, **kwargs, &block)
      end

      def select_group(name, choices = nil, selected: nil, include_blank: false, label: nil, **kwargs, &block)
        render new_group(name, **kwargs) do |g|
          g.with_label(label) if label.present?
          g.select(choices, selected:, include_blank:)
        end
      end

      def with_select_group(name, choices = nil, selected: nil, include_blank: false, label: nil, **kwargs, &block)
        with_group(name, **kwargs) do |g|
          g.with_label(label) if label.present?
          g.select(choices, selected:, include_blank:)
        end
      end

      def field_group(*args, **kwargs, &block)
        render new_group(*args, **kwargs), &block
      end

      def buttons(*args, **kwargs, &block)
        render new_buttons(*args, **kwargs), &block
      end
    end
  end
end
