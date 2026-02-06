# frozen_string_literal: true

module RapidUI
  module Datatable
    class FooterExports < ApplicationComponent
      attr_reader :table

      def initialize(table:, **kwargs)
        super(
          **kwargs,
          class: merge_classes("datatable-exports", kwargs[:class])
        )
        @table = table
      end

      def call
        component_tag do
          safe_join([
            tag.div("Download:"),
            *table.export_formats.map do |format|
              link_to(table.send(:t, "export.formats.#{format}"), table.table_path(format:))
            end,
          ])
        end
      end
    end
  end
end
