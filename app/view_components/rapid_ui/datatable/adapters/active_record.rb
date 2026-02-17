# frozen_string_literal: true

module RapidUI
  module Datatable
    module Adapters
      # RapidUI datatable rendering ActiveRecord relations.
      module ActiveRecord
        extend ActiveSupport::Concern

        included do
          include Search if include?(Datatable::Search)
          include Sorting if include?(Datatable::Sorting)
        end

        def each_row(batch_size: nil, &block)
          rows.unscope(:limit, :offset).find_each(batch_size:, &block)
        end

        def row_id(row)
          row.send(row.class.primary_key)
        end

        # RapidUI datatable sorting functionality for ActiveRecord.
        # Base Datatable::Sorting already registers the :sorting filter; we only override filter_sorting.
        module Sorting
          extend ActiveSupport::Concern

          included do
            column_class! do
              attr_accessor :nulls_last
              alias_method :nulls_last?, :nulls_last
            end
          end

          def filter_sorting(scope)
            return scope if skip_sorting?
            return filter_sorting_nulls_last(scope) if sort_column.nulls_last?

            scope.reorder(nil).order(sort_column.id => sort_order)
          end

          def filter_sorting_nulls_last(scope)
            # be extra careful about SQL injection here even though
            # these values should be coming our code, not the request.
            id = ::ActiveRecord::Base.connection.quote_column_name(sort_column.id)
            raise ArgumentError unless %w[asc desc].include?(sort_order)

            scope.reorder(nil).order(::Arel.sql("#{id} #{sort_order} NULLS LAST"))
          end
        end

        # RapidUI datatable search functionality for ActiveRecord.
        module Search
          extend ActiveSupport::Concern

          def filter_search(scope)
            scope.search(search_query)
          end

          def skip_search?
            super || !active_record_class_has_search_scope?
          end

          private

          def active_record_class_has_search_scope?
            unfiltered_rows.is_a?(::ActiveRecord::Relation) && unfiltered_rows.klass.respond_to?(:search)
          end
        end
      end
    end
  end
end
