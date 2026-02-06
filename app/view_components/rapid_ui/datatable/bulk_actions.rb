module RapidUI
  module Datatable
    class BulkActions < ApplicationComponent
      def initialize(table:, **kwargs)
        super(**kwargs)

        @table = table
      end

      def call
        component_tag { safe_join([select_tag, submit_tag]) }
      end

      private

      def select_tag
        @table.bulk_actions_select_tag(class: "datatable-select")
      end

      def submit_tag
        @table.bulk_actions_submit_tag(class: "btn btn-naked datatable-button")
      end
    end
  end
end
