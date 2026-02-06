# frozen_string_literal: true

module RapidUI
  module Datatable
    class FooterPagination < ApplicationComponent
      attr_reader :table

      def initialize(table:, **kwargs)
        super(**kwargs)
        @table = table
      end
    end
  end
end
