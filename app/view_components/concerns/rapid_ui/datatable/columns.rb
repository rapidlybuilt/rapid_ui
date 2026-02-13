# frozen_string_literal: true

module RapidUI
  module Datatable
    # The Columns module provides functionality for defining and managing table columns
    # in RapidUI. It exposes the following configuration options to RapidUI::Datatable::Base:
    #
    # @option config columns [Array<Hash, Column>] The columns to display in the table.
    #   Can be specified as:
    #   - Hashes: columns [{id: :name, label: "Full Name"}, {id: :email}]
    #   - Column objects: columns [column1, column2]
    # @option config column_ids [Array<Symbol>] Column IDs to include (via DSL)
    # @option config column_group_id [Symbol] Column group ID to use (via DSL)
    # @option config except [Array, Symbol] Column IDs to exclude from the table
    # @option config only [Array, Symbol] Column IDs to include in the table
    #
    # When using hashes, each hash supports:
    # @option config column.id [Symbol] The column identifier
    # @option config column.label [String] The column label (optional)
    #
    # @example Basic DSL usage
    #   class MyTable < RapidUI::Datatable::Base
    #     column :id
    #     column :name
    #     column :email
    #     column :created_at
    #   end
    #
    # @example With custom labels and cell methods
    #   class MyTable < RapidUI::Datatable::Base
    #     column :id, label: "ID"
    #     column :name, label: "Full Name"
    #     column :email
    #
    #     # custom cell method receives record and column
    #     cell_value :email do |record|
    #       record.email.downcase
    #     end
    #   end
    #
    # @example With column groups
    #   class MyTable < RapidUI::Datatable::Base
    #     column :id
    #     column :name
    #     column :email
    #     column :created_at
    #
    #     # allow rendering this table with a preconfigured subset of columns
    #     column_group :basic, [:name, :email]
    #   end
    module Columns
      extend ActiveSupport::Concern

      class ColumnNotFoundError < RapidUI::Error; end
      class ColumnGroupNotFoundError < RapidUI::Error; end

      included do
        include RapidUI::Support::ExtendableClass
        include RapidUI::Support::I18n

        class_attribute :column_group_id, default: :default
        class_attribute :column_types, default: {}

        attr_reader :column_group
        attr_writer :columns

        def_extendable_class :column, superclass: Column do
          attr_accessor :label_method
          attr_accessor :value_method
        end

        def_extendable_class :column_group do
          attr_accessor :id
          attr_accessor :column_ids
        end
      end

      def columns
        return @columns if defined?(@columns)

        @columns = build_columns
      end

      # Renders the label for a given column.
      #
      # @param column [Object] The column object containing id and label information
      # @return [String] The rendered HTML span element containing the column label
      def column_label(column)
        column = polish_column_argument(column)

        label_method = column.label_method || :default_column_label
        send(label_method, column)
      end

      # Renders the cell content for HTML display.
      #
      # @param record [Object] The record object to render the cell for
      # @param column [Object] The column object defining how to render the cell
      # @return [String] The rendered cell content
      def column_cell_html(record, column)
        column = polish_column_argument(column)

        method_name = column.cell_method_for(:html) ||
          column.cell_method_for(:default) ||
          :column_cell_value

        send(method_name, record, column)
      end

      # Renders the header cell for a given column.
      #
      # @param column [Object] The column object to render the header for
      # @return [String] The rendered header cell content
      def th_tag(column)
        column = polish_column_argument(column)

        method_name = column.cell_method_for(:th) || :th_tag_default
        send(method_name, column)
      end

      # Renders the data cell for a given column and row.
      #
      # @param column [Object] The column object to render the data for
      # @param row [Object] The row object to render the data for
      # @return [String] The rendered data cell content
      def td_tag(column, row)
        column = polish_column_argument(column)

        method_name = column.cell_method_for(:td) || :td_tag_default
        send(method_name, column, row)
      end

    private

      def polish_column_argument(column)
        column = self.class.find_column!(column) if column.is_a?(Symbol)
        column
      end

      # A simple <th scope="col"> tag
      def th_tag_default(column, **options)
        tag.th(column_label(column), scope: "col", **options)
      end

      # A simple <td> tag
      def td_tag_default(column, row)
        tag.td(column_cell_html(row, column))
      end

      # Returns the cell value for a given record and column.
      # This is the base implementation used by format-specific methods.
      #
      # @param record [Object] The record object to render the cell for
      # @param column [Object] The column object defining how to render the cell
      # @return [Object] The cell value
      def column_cell_value(record, column)
        record.send(column.id)
      end

      # Builds the columns for the table.
      #
      # @param columns [Array] The columns to build
      # @param column_ids [Array] The column IDs to build
      # @param column_group_id [Symbol] The column group ID to build
      # @param except [Array] The column IDs to exclude
      # @param only [Array] The column IDs to include
      # @return [Array] The built columns
      def build_columns(columns: nil, column_ids: nil, column_group_id: nil, except: nil, only: nil)
        return unless column_ids || column_group_id || self.class.columns.any?

        @column_group = self.class.find_column_group!(column_group_id) if column_group_id
        @column_group = self.class.find_column_group(:default) if @column_group.nil? && !column_ids
        columns = self.class.find_columns!(column_ids:, column_group_id: @column_group&.id)

        except = [ except ] if except && !except.is_a?(Array)
        only = [ only ] if only && !only.is_a?(Array)

        columns = columns.reject { |column| except.include?(column.id) } if except
        columns = columns.select { |column| only.include?(column.id) } if only
        columns
      end

      # Returns the default column label for a column.
      #
      # @param column [Object] The column object
      # @return [String] The column label
      def default_column_label(column)
        id = column.id
        column.label || t("columns.#{id}") || id.to_s.titleize
      end

      # Class methods for column DSL configuration.
      module ClassMethods
        # Defines a new column for this table.
        #
        # @param id [Symbol] The unique identifier for the column
        # @param options [Hash] Additional options for the column (label, etc.)
        # @return [Object] The created column object
        # @example
        #   column :id, label: "ID"
        #   column :email
        def column(id, **options)
          columns_by_id[id] = build_column(**options, id:)
        end

        # Defines a new column group for this table.
        #
        # @param id [Symbol] The unique identifier for the column group
        # @param column_ids [Array<Symbol>] The column IDs to include in this group
        # @param options [Hash] Additional options for the column group
        # @return [Object] The created column group object
        # @example
        #   column_group :basic_info, [:id, :name, :email]
        def column_group(id, column_ids, **options)
          column_groups_by_id[id] = build_column_group(**options, id:, column_ids:)
        end

        # Defines a new column type for this table.
        #
        # @param type [Symbol] The type of column
        # @param block [Proc] The block to define the column type
        # @return [void]
        # @example
        #   column_type :string do |value|
        #     "STRING: #{value}"
        #   end
        #
        #   # this type can then be used to define columns
        #   columns do |t|
        #     t.string :id
        #   end
        def column_type(type, format = :default, &block)
          name = :"column_type_#{type}_#{format}"
          define_method(name) do |record, column|
            value = column_cell_value(record, column)
            instance_exec(value, &block) unless value.nil?
          end

          self.column_types[type] ||= {}
          self.column_types[type][format] = name
        end

        # Gets all defined columns for this table, including inherited ones.
        #
        # @param block [Proc] The block to define the columns by type
        # @return [Array<Object>] Array of column objects
        def columns
          if block_given?
            builder = Builder.new(self)
            yield builder
          end

          ((superclass&.columns if superclass.respond_to?(:columns)) || []) +
            columns_by_id.values
        end

        # Gets all defined column groups for this table, including inherited ones.
        #
        # @return [Array<Object>] Array of column group objects
        def column_groups
          ids = superclass.send(:column_groups_by_id) if superclass.respond_to?(:column_groups_by_id, true)

          (ids || {}).merge(column_groups_by_id).values
        end

        # Finds a column by ID, searching up the inheritance chain.
        #
        # @param column_id [Symbol] The ID of the column to find
        # @return [Object, nil] The found column or nil if not found
        def find_column(column_id)
          columns_by_id[column_id] ||
            (superclass&.find_column(column_id) if superclass.respond_to?(:find_column))
        end

        # Finds a column by ID, raising an error if not found.
        #
        # @param column_id [Symbol] The ID of the column to find
        # @return [Object] The found column
        # @raise [Columns::ColumnNotFoundError] If the column is not found
        def find_column!(column_id)
          find_column(column_id) || raise(ColumnNotFoundError, "Column #{column_id} not found")
        end

        # Finds a column group by ID, searching up the inheritance chain.
        #
        # @param group_id [Symbol] The ID of the column group to find
        # @return [Object, nil] The found column group or nil if not found
        def find_column_group(group_id)
          column_groups_by_id[group_id] ||
            (superclass.find_column_group(group_id) if superclass.respond_to?(:find_column_group))
        end

        # Finds the default column group.
        #
        # @return [Object] The found column group
        def default_column_group
          find_column_group!(:default)
        end

        # Finds a column group by ID, raising an error if not found.
        #
        # @param group_id [Symbol] The ID of the column group to find
        # @return [Object] The found column group
        # @raise [Columns::ColumnGroupNotFoundError] If the column group is not found
        def find_column_group!(group_id)
          find_column_group(group_id) || raise(Columns::ColumnGroupNotFoundError, "Column group #{group_id} not found")
        end

        # Finds columns by IDs or column group ID.
        #
        # @param column_ids [Array<Symbol>, nil] The column IDs to find
        # @param column_group_id [Symbol, nil] The column group ID to find columns for
        # @return [Array<Object>] Array of found column objects
        # @raise [ArgumentError] If both column_ids and column_group_id are specified
        # @raise [ArgumentError] If neither column_ids nor column_group_id is specified
        def find_columns!(column_ids: nil, column_group_id: nil)
          raise ArgumentError, "column_ids and column_group_id cannot be used together" if column_ids && column_group_id

          if column_ids
            column_ids.map { |id| find_column!(id) }
          elsif column_group_id
            find_columns!(column_ids: find_column_group!(column_group_id).column_ids)
          else
            columns_by_id.values
          end
        end

        # Defines a custom HTML cell method for a column.
        #
        # @param column_id [Symbol] The ID of the column
        # @param block [Proc] The block to define the HTML cell method
        # @return [void]
        def cell_value(column_id, format = :default, &)
          format = format.to_sym
          column = find_column!(column_id)

          name = :"column_cell_#{format}_#{column_id}"
          define_column_method(name, &)
          column.cell_methods_by_format[format] = name
        end

      private

        # Returns the registry of columns by ID.
        #
        # @return [Hash<Symbol, Object>] The registry of columns
        def columns_by_id
          @columns_by_id ||= {}
        end

        # Returns the registry of column groups by ID.
        #
        # @return [Hash<Symbol, Object>] The registry of column groups
        def column_groups_by_id
          @column_groups_by_id ||= { default: build_column_group(id: :default) }
        end

        # Allows the column method to optionally receive a column object as the second argument
        # but most of the time it's redundant/unnecessary.
        def define_column_method(name, &block)
          if block.arity == 1
            define_method(name) { |record, _column| instance_exec(record, &block) }
          else
            define_method name, &block
          end
        end
      end

      # Builder for the column DSL.
      class Builder
        def initialize(klass)
          @klass = klass
        end

        def method_missing(method, *args, **kwargs, &)
          # must match our column_type method signature
          super if args.length != 1 || block_given?

          super unless @klass.column_types.key?(method)

          # define the column and set the value methods from the type
          column = @klass.column(args.first, **kwargs)
          column.cell_methods_by_format.merge!(@klass.column_types[method])
          column
        end

        def respond_to_missing?(method, include_private = false)
          @klass.method_defined?(:"column_type_#{method}") || super
        end
      end
    end
  end
end
