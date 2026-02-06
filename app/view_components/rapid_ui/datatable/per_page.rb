# frozen_string_literal: true

module RapidUI
  module Datatable
    class PerPage < ApplicationComponent
      attr_reader :table

      def initialize(table:, **kwargs)
        super(
          tag_name: :label,
          **kwargs,
        )

        @table = table
      end

      def call
        component_tag do
          safe_join([
            tag.label("Per Page:"),
            table.per_page_select_tag(class: "datatable-select datatable-per-page-select", autocomplete: "off"),
          ])
        end
      end
    end
  end
end
