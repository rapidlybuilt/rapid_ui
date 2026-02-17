module RapidUI
  module Datatable
    module Rows
      extend ActiveSupport::Concern

      included do
        include RapidUI::Support::RegisterProcs

        def_registered_procs :filter
      end

      attr_accessor :unfiltered_rows

      with_options to: :rows do
        delegate :empty?
        delegate :any?
      end

      def rows
        @rows ||= apply_filters(unfiltered_rows)
      end

      def reset_rows
        @rows = nil
      end

      def row_tag(row, &block)
        tag.tr(id: dom_id(row), &block)
      end

      def dom_id(record)
        super if record.respond_to?(:to_key)
      end

      def row_id(row)
        row.id
      end

      private

      def apply_filters(scope)
        # support delayed execution via procs in case we end up not needing the data.
        scope = scope.call if scope.is_a?(Proc)

        self.class.filter_procs.inject(scope) do |scope, filter_proc|
          apply_proc(:filter, filter_proc, scope) || scope
        end
      end
    end
  end
end
