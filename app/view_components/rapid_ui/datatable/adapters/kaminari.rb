# frozen_string_literal: true

module RapidUI
  module Datatable
    module Adapters
      # Kaminari functionality for RapidUI datatable
      module Kaminari
        extend ActiveSupport::Concern
        include Datatable::Pagination

        included do
          register_filter :kaminari, unless: :skip_pagination?

          with_options to: :records do
            delegate :total_pages
            delegate :current_page
          end
        end

        def filter_kaminari(scope)
          scope.page(page).per(per_page)
        end

        def total_records_count
          records.total_count
        end
      end
    end
  end
end
