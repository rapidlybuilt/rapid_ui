# frozen_string_literal: true

module RapidUI
  module Datatable
    class Base < RapidTable::Base
      extend RapidTable::DSL

      def initialize(*args, **kwargs, &block)
        super(*args, **kwargs, &block)

        self.stimulus_controller = "datatable"
      end
    end
  end
end
