module RapidUI
  module Datatable
    module BulkActions
      class Container < ApplicationComponent
        def initialize(table:, **kwargs)
          super(**kwargs)

          @table = table
        end

        def call
          component_tag { safe_join([select_tag, submit_tag]) }
        end

        private

        def select_tag
          bulk_actions_select_tag(class: "datatable-select")
        end

        def submit_tag
          bulk_actions_submit_tag(class: "btn btn-naked datatable-button")
        end

        # Gets the display label for a bulk action, with fallback to translation or titleized ID.
        #
        # @param bulk_action [Object] The bulk action object
        # @return [String] The display label for the bulk action
        def bulk_action_label(bulk_action)
          bulk_action.label || @table.t("bulk_actions.#{bulk_action.id}") || bulk_action.id.to_s.titleize
        end

        # Renders a select dropdown for choosing which bulk action to perform.
        #
        # @param options [Hash] Additional HTML options for the select tag
        # @return [String] The rendered select tag HTML
        def bulk_actions_select_tag(**options)
          placeholder_choice = [@table.t("bulk_actions.placeholder"), nil]
          choices = @table.bulk_actions.map { |bulk_action| [bulk_action_label(bulk_action), bulk_action.id] }

          helpers.select_tag(
            nil, # JavaScript cleverness will submit the bulk action
            options_for_select([placeholder_choice] + choices),
            id: @table.id_for(:bulk_actions),
            autocomplete: "off",
            **options,
            data: @table.hotwire_data(
              options,
              action: @table.stimulus_action("change", "toggleBulkActionPerform"),
              @table.stimulus_target => "bulkActionSelect",
            ),
          )
        end

        # Renders a submit button for performing the selected bulk action.
        #
        # @param path [String] The URL to submit the bulk action to (defaults to bulk_action action)
        # @param method [String] The HTTP method for the form (default: "POST")
        # @param options [Hash] Additional HTML options for the submit button
        # @return [String] The rendered submit button HTML
        def bulk_actions_submit_tag(path: @table.table_path(action: :bulk_action), method: "POST", **options)
          helpers.submit_tag(
            @table.t("bulk_actions.button"),
            title: @table.t("bulk_actions.button_title"),
            **options,
            data: @table.hotwire_data(
              options,
              action: @table.stimulus_action("click", "submitBulkAction"),
              @table.stimulus_target => "bulkActionPerform",
              param: @table.bulk_actions_param,
              path:,
              method:,
            ),
          )
        end
      end
    end
  end
end
