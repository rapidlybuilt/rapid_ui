# frozen_string_literal: true

module RapidUI
  module Datatable
    class FooterPerPage < ApplicationComponent
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
            table.per_page_select_tag(class: "datatable-select datatable-per-page-select"),
          ])
        end
      end
    end
  end
end
