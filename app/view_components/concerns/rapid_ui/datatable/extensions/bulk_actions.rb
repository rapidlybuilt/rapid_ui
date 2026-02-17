# frozen_string_literal: true

module RapidUI
  module Datatable
    module Extensions
      # The BulkActions module provides functionality for performing actions on multiple selected
      # records in RapidUI datatable. It exposes the following configuration options to RapidUI::Datatable::Base:
      #
      # @option config skip_bulk_actions [Boolean] Whether to disable bulk actions entirely
      # @option config bulk_actions [Array<BulkAction>] The bulk actions available for the table
      # @option config bulk_action_ids_param [Symbol] The parameter name for selected record IDs (default: :ids)
      #
      # Bulk action configuration:
      # @option config bulk_action.id [Symbol] The unique identifier for the bulk action
      # @option config bulk_action.label [String] The display label for the bulk action (optional)
      #
      # @example Basic usage
      #   class MyTable < RapidUI::Datatable::Base
      #     self.skip_bulk_actions = false
      #     self.bulk_action_ids_param = :selected_ids
      #
      #     bulk_action :delete
      #     bulk_action :archive, label: "Archive Selected"
      #   end
      #
      # @example With bulk actions disabled
      #   class MyTable < RapidUI::Datatable::Base
      #     self.skip_bulk_actions = true
      #   end
      module BulkActions
        extend ActiveSupport::Concern

        included do
          include Columns

          include Support::HasStimulusController
          include Support::HasPersistentParams

          prepend InstanceOverrides

          class_attribute :skip_bulk_actions, default: false, instance_reader: false
          class_attribute :bulk_action_ids_param, default: :ids
          persistent_param :bulk_action_ids_param

          attr_writer :skip_bulk_actions

          if respond_to?(:register_control)
            register_control :bulk_actions, ->(**kwargs) { build(BulkActions::Container, table:, **kwargs) }
          end

          def_extendable_class :bulk_action do
            attr_accessor :id
            attr_accessor :label
          end
        end

        # Gets the IDs of records currently selected for bulk actions.
        #
        # @return [Array<String>] Array of selected record IDs
        def selected_bulk_action_record_ids
          # TODO: only retain these when just performed a bulk action
          @selected_bulk_action_record_ids ||= full_params[bulk_action_ids_param] || []
        end

        # Checks if a specific record is currently selected for bulk actions.
        #
        # @param record [Object] The record to check
        # @return [Boolean] True if the record is selected, false otherwise
        def selected_bulk_action_record?(record)
          selected_bulk_action_record_ids.include?(row_id(record).to_s)
        end

        def bulk_actions
          # all bulk actions by default
          @bulk_actions ||= self.class.bulk_actions.dup
        end

        def bulk_actions=(actions)
          @bulk_actions = self.class.build_bulk_actions(actions)
        end

        def bulk_action_ids=(ids)
          @bulk_actions = ids.map { |id| self.class.find_bulk_action!(id) }
        end

        def bulk_action_ids
          bulk_actions.map(&:id)
        end

        def skip_bulk_actions?
          skip = defined?(@skip_bulk_actions) ? @skip_bulk_actions : self.class.skip_bulk_actions?
          skip || bulk_actions.empty?
        end
        alias_method :skip_bulk_actions, :skip_bulk_actions?

        private

        # Inserts a bulk action column into the columns array that allows selecting individual records for bulk actions.
        #
        # @return [void]
        def build_bulk_action_column
          column = self.class.column_class.new(
            label_method: :bulk_actions_select_all_check_box_tag,
          )

          column.cell_methods_by_format[:html] = :bulk_actions_select_one_check_box_tag
          column.cell_methods_by_format[:th] = :bulk_actions_th_tag
          column.skip_export = true if column.respond_to?(:skip_export?)
          column
        end

        def bulk_actions_th_tag(column)
          # make the column very narrow / square
          th_tag_default(column, class: "w-8")
        end

        # Renders a "select all" checkbox for bulk actions.
        #
        # @param options [Hash] Additional HTML options for the checkbox
        # @return [String] The rendered checkbox HTML
        def bulk_actions_select_all_check_box_tag(column = nil, **options)
          helpers.check_box_tag(
            "select_all",
            nil,
            false,
            **options,
            data: stimulus_controller.merge(
              options[:data],
              action: stimulus_controller.actions(
                "change", "toggleBulkActionsSelections",
                "change", "toggleBulkActionPerform",
              ),
            ),
          )
        end

        # Renders a checkbox for selecting an individual record for bulk actions.
        #
        # @param record [Object] The record to create a checkbox for
        # @param options [Hash] Additional HTML options for the checkbox
        # @return [String] The rendered checkbox HTML
        def bulk_actions_select_one_check_box_tag(record, column = nil, **options)
          id = row_id(record)

          helpers.check_box_tag(
            "#{bulk_action_ids_param}[]",
            id,
            selected_bulk_action_record?(record),
            id: "#{id}_select_#{id}",
            title: "Select",
            **options,
            data: stimulus_controller.merge(
              options[:data],
              stimulus_controller.target => "bulkActionsRowSelect",
              action: stimulus_controller.action("change", "toggleBulkActionPerform"),
            ),
          )
        end

        module InstanceOverrides
          def build_columns(**kwargs)
            columns = super
            columns.insert(0, build_bulk_action_column) unless skip_bulk_actions?
            columns
          end
        end

        # Class methods for bulk action DSL configuration.
        module ClassMethods
          # Defines a new bulk action for this table.
          #
          # @param id [Symbol] The unique identifier for the bulk action
          # @param label [String, nil] The display label for the bulk action (optional)
          # @param options [Hash] Additional options for the bulk action
          # @return [Object] The created bulk action object
          # @example
          #   bulk_action :delete, label: "Delete Selected"
          def bulk_action(id, label: nil, **options)
            bulk_actions_by_id[id] = build_bulk_action(**options, id:, label:)
          end

          # Gets all defined bulk actions for this table.
          #
          # @return [Array<Object>] Array of bulk action objects
          def bulk_actions
            (superclass.respond_to?(:bulk_actions) ? superclass.bulk_actions : []) +
              bulk_actions_by_id.values
          end

          # Finds a bulk action by ID, searching up the inheritance chain.
          #
          # @param id [Symbol] The ID of the bulk action to find
          # @return [Object, nil] The found bulk action or nil if not found
          # @raise [ArgumentError] If the bulk action is not found
          def find_bulk_action(id)
            bulk_actions_by_id[id] ||
              (superclass&.find_bulk_action(id) if superclass.respond_to?(:find_bulk_action)) ||
              raise(ArgumentError, "Bulk action #{id} not found")
          end

          # Finds a bulk action by ID, raising an error if not found.
          #
          # @param id [Symbol] The ID of the bulk action to find
          # @return [Object] The found bulk action
          # @raise [ArgumentError] If the bulk action is not found
          def find_bulk_action!(id)
            find_bulk_action(id) || raise(ArgumentError, "Bulk action #{id} not found")
          end

        private

          # Returns the registry of bulk actions by ID.
          #
          # @return [Hash<Symbol, Object>] The registry of bulk actions
          def bulk_actions_by_id
            @bulk_actions_by_id ||= {}
          end
        end
      end
    end
  end
end
