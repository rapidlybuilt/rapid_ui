module RapidUI
  module Form
    class SelectTag < ApplicationComponent
      attr_accessor :name
      attr_accessor :options
      attr_accessor :selected
      attr_accessor :required

      alias_method :required?, :required

      def initialize(name:, options: [], selected: nil, required: false, **kwargs)
        super(**kwargs)

        @name = name
        @options = options
        @selected = selected
        @required = required

        yield self if block_given?
      end

      def call
        attrs = {
          id:,
          name:,
          class: "form-select",
        }
        attrs[:required] = true if required?

        tag.select(**attrs) do
          safe_join(options.map { |option| option_tag(option) })
        end
      end

      private

      def option_tag(option)
        is_selected = (option == selected)
        tag.option(option, value: option, selected: is_selected)
      end
    end
  end
end
