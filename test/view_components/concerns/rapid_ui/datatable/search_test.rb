# frozen_string_literal: true

require "test_helper"

module RapidUI
  module Datatable
    class SearchTest < ViewComponent::TestCase
      include ExtensionSupport
      include I18nSupport

      class SearchTable < ExtensionSupport::TestComponent
        include Search

        def call ; end
      end

      test "search_query returns param value" do
        table = SearchTable.new(param_name: :t, full_params: { t: { q: "hello" } })
        assert_equal "hello", table.search_query
      end

      test "filter_search raises AdapterRequiredError" do
        table = SearchTable.new
        error = assert_raises(RapidUI::AdapterRequiredError) { table.filter_search([]) }
        assert_includes error.message, "not implemented"
      end

      test "search control is registered" do
        klass = Class.new ViewComponent::Base do
          include Controls
          include Search
        end

        assert_registers_control :search_field_form, klass
      end
    end
  end
end
