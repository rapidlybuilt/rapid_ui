# frozen_string_literal: true

module RapidUI
  module Datatable
    class Pagination < ApplicationComponent
      attr_reader :table

      def initialize(table:, **kwargs)
        super(
          tag_name: :div,
          **kwargs,
          class: merge_classes("datatable-paginate", kwargs[:class])
        )
        @table = table
      end

      def call
        component_tag do
          table.pagination_links
        end
      end
    end
  end
end
