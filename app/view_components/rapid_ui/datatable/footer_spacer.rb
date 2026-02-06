# frozen_string_literal: true

module RapidUI
  module Datatable
    class FooterSpacer < ApplicationComponent
      def initialize(table: nil, **kwargs)
        super(**kwargs)
      end

      def call
        tag.div
      end
    end
  end
end
