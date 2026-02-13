# frozen_string_literal: true

module RapidUI
  module Datatable
    module Extensions
      # The Export module provides functionality for exporting table data in various formats
      # in RapidUI datatable. It exposes the following configuration options to RapidUI::Datatable::Base:
      #
      # @option config csv_column_separator [String] The separator to use for CSV exports (default: ",")
      # @option config export_batch_size [Integer] The number of records to process in each batch (default: 1000)
      # @option config export_formats [Array<Symbol>] The formats available for export (default: [:csv, :json])
      # @option config skip_export [Boolean] Whether to skip export functionality entirely
      #
      # Column-level export options:
      # @option config column.skip_export [Boolean] Whether to exclude this column from exports
      #
      # @example Basic usage
      #   class MyTable < RapidUI::Datatable::Base
      #     self.skip_export = false
      #     self.csv_column_separator = ";"
      #     self.export_batch_size = 500
      #   end
      #
      # @example With export disabled
      #   class MyTable < RapidUI::Datatable::Base
      #     self.skip_export = true
      #   end
      module Export
        extend ActiveSupport::Concern

        included do
          include Columns
          include Rows
          include Support::HasPersistentParams

          class_attribute :skip_export, default: false
          class_attribute :csv_column_separator, default: ","
          class_attribute :export_batch_size, default: 1000
          class_attribute :export_formats, default: %i[csv json]

          column_class! do
            attr_accessor :skip_export
            alias_method :skip_export?, :skip_export

            attr_accessor :export_method
            attr_accessor :csv_method
            attr_accessor :json_method
          end

          if respond_to?(:register_control)
            register_control :exports, ->(**kwargs) do
              build(
                Links,
                table.export_formats,
                path_proc: ->(format) { table.table_path(format:) },
                **kwargs,
              )
            end
          end
        end

        # Returns columns that should be included in exports, filtering out those marked as skip_export.
        #
        # @return [Array<Column>] The columns to include in exports
        def export_columns
          columns.clone.reject(&:skip_export?)
        end

        # Streams CSV data to the provided stream object.
        #
        # @param stream [IO] The stream to write CSV data to
        # @return [void]
        def csv_stream
          CsvStream.new filename: csv_export_filename do |stream|
            row_sep = "\n"
            stream.write(CSV.generate_line(export_columns.map(&:id), row_sep:))

            each_row(batch_size: export_batch_size) do |record|
              cells = export_columns.map do |column|
                column_cell_csv(record, column)
              end

              stream.write(CSV.generate_line(cells, row_sep:))
            end
          end
        end

        # Exports table data as JSON.
        #
        # @return [Array<Hash>] Array of hashes representing table records
        def to_json(*_args)
          data = []

          each_row(batch_size: export_batch_size) do |record|
            data << export_columns.each_with_object({}) do |column, hash|
              hash[column.id] = column_cell_json(record, column)
            end
          end

          data
        end

        # Returns the cell value formatted for CSV export.
        #
        # @param record [Object] The record object to render the cell for
        # @param column [Object] The column object defining how to render the cell
        # @return [Object] The cell value for CSV
        def column_cell_csv(record, column)
          column_cell_export(record, column, :csv)
        end

        # Returns the cell value formatted for JSON export.
        #
        # @param record [Object] The record object to render the cell for
        # @param column [Object] The column object defining how to render the cell
        # @return [Object] The cell value for JSON
        def column_cell_json(record, column)
          column_cell_export(record, column, :json)
        end

        # rubocop:disable Lint/UnusedMethodArgument

        # Iterates over records for export processing.
        # By default, yields each record in turn.
        # Extensions may override for optimal batch or paged access.
        #
        # @param batch_size [Integer, nil] The number of records to process in each batch (optional, for extensions)
        # @yield [record] Block to execute for each record
        def each_row(batch_size: nil, &block)
          raise AdapterRequiredError
        end
        # rubocop:enable Lint/UnusedMethodArgument

        def skip_export?
          super || export_formats.empty?
        end

        private


        # Returns the cell value formatted for a specific export format.
        #
        # @param record [Object] The record object to render the cell for
        # @param column [Object] The column object defining how to render the cell
        # @param format [Symbol] The export format
        # @return [Object] The cell value for that export format
        def column_cell_export(record, column, format)
          column = self.class.find_column!(column) if column.is_a?(Symbol)

          csv_method = column.cell_method_for(format) ||
            column.cell_method_for(:export) ||
            column.cell_method_for(:default) ||
            :column_cell_value

          send(csv_method, record, column)
        end

        def csv_export_filename
          "#{self.class.name&.underscore&.gsub(%r{[/_]}, "-")}-#{Time.now.strftime("%Y-%m-%d")}.csv"
        end

        # The ClassMethods module provides methods for defining custom export methods for columns.
        module ClassMethods
          # Defines logic for a exporting a column to CSV/JSON.
          #
          # @param column_id [Symbol] The ID of the column
          # @param block [Proc] The block to define the export method
          # @return [void]
          def column_export(column_id, &)
            column = find_column!(column_id)

            name = :"column_cell_export_#{column_id}"
            define_column_method(name, &)
            column.export_method = name
          end

          # Defines logic for a exporting a column to CSV.
          #
          # @param column_id [Symbol] The ID of the column
          # @param block [Proc] The block to define the CSV method
          # @return [void]
          def column_csv(column_id, &)
            column = find_column!(column_id)

            name = :"column_cell_csv_#{column_id}"
            define_column_method(name, &)
            column.csv_method = name
          end

          # Defines logic for a exporting a column to JSON.
          #
          # @param column_id [Symbol] The ID of the column
          # @param block [Proc] The block to define the JSON method
          # @return [void]
          def column_json(column_id, &)
            column = find_column!(column_id)

            name = :"column_cell_json_#{column_id}"
            define_column_method(name, &)
            column.json_method = name
          end
        end

        class Links < ApplicationComponent
          include RapidUI::Support::I18n

          attr_reader :formats

          attr_accessor :link_options

          def initialize(formats, path_proc:, **kwargs)
            super(
              **kwargs,
              class: merge_classes("datatable-exports", kwargs[:class])
            )

            @formats = formats
            @path_proc = path_proc
            @link_options = {}
          end

          def call
            component_tag do
              safe_join([ title, *links ])
            end
          end

          def title
            t("title")
          end

          def links
            formats.map do |format|
              link_for(format)
            end
          end

          private

          def path_for(format)
            @path_proc.call(format)
          end

          def link_for(format)
            text = t("formats.#{format}")
            link_to(text, path_for(format), @link_options)
          end
        end
      end
    end
  end
end
