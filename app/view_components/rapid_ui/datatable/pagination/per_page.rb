# frozen_string_literal: true

module RapidUI
  module Datatable
    module Pagination
      class PerPage < ApplicationComponent
        attr_reader :table, :select_options

        def initialize(table:, select_options: {}, **kwargs)
          super(
            tag_name: :label,
            **kwargs,
          )

          @table = table
          @select_options = select_options
        end

        def call
          component_tag do
            default_options = { class: "datatable-select datatable-per-page-select", autocomplete: "off" }
            safe_join([
              tag.label("Per Page:"),
              select_tag_html(**default_options.merge(select_options)),
            ])
          end
        end

        private

        def table_path
          raise ExtensionRequiredError, "table_path is not implemented"
        end

        # Renders the select dropdown for choosing the number of records per page.
        # Can be called from the component or via the class method with a table and view context.
        #
        # @param options [Hash] Additional HTML options for the select tag
        # @return [String] The rendered select tag HTML
        def select_tag_html(**options)
          paginated_url = ->(per_page) do
            table.table_path(table.page_param => 1, table.per_page_param => per_page)
          end

          choices = table.available_per_pages.map do |per_page|
            [per_page, paginated_url.call(per_page)]
          end

          selected_url = paginated_url.call(table.per_page)

          data = table.hotwire_data(
            action: table.stimulus_action("change", "navigateFromSelect"),
            table.stimulus_target => "perPageSelect",
          )

          helpers.select_tag(
            table.param_name(table.per_page_param),
            helpers.options_for_select(choices, selected_url),
            **options,
            data:,
          )
        end
      end
    end
  end
end
