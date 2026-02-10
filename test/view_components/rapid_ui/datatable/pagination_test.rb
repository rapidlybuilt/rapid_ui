# frozen_string_literal: true

require_relative "../view_component_test_case"

module RapidUI
  module Datatable
    class PaginationTest < ViewComponent::TestCase
      include ExtensionSupport

      class PaginationTable < ExtensionSupport::TestComponent
        include Support::Params
        include Support::I18n
        include Support::Hotwire
        include Pagination

        def call
          ""
        end

        # Stub to avoid url_for in tests
        def table_path(view_context: nil, format: nil, **options)
          "/?#{options.to_query}"
        end
      end

      test "skip_pagination defaults to false" do
        table = PaginationTable.new
        assert_equal false, table.skip_pagination?
      end

      test "skip_pagination can be overridden" do
        table = PaginationTable.new(skip_pagination: true)
        assert_equal true, table.skip_pagination?
      end

      test "per_page uses config default when no param" do
        table = PaginationTable.new(per_page: 50)
        assert_equal 50, table.per_page
      end

      test "per_page uses param when present" do
        table = PaginationTable.new(params: { "t" => { per: "100" } }, param_name: "t")
        assert_equal 100, table.per_page
      end

      test "per_page uses param value even when not in available_per_pages" do
        table = PaginationTable.new(params: { "t" => { per: "99" } }, param_name: "t")
        assert_equal 99, table.per_page
      end

      test "page defaults to 1 when no param" do
        table = PaginationTable.new
        assert_equal 1, table.page
      end

      test "page uses param when present" do
        table = PaginationTable.new(params: { "t" => { page: "3" } }, param_name: "t")
        assert_equal 3, table.page
      end

      test "page is 1 when param less than 1" do
        table = PaginationTable.new(params: { "t" => { page: "0" } }, param_name: "t")
        assert_equal 1, table.page
      end

      test "only_ever_one_page? when skip_pagination" do
        table = PaginationTable.new(skip_pagination: true)
        assert_equal true, table.only_ever_one_page?
      end

      test "per_page_param_value and page_param_value" do
        table = PaginationTable.new(params: { "t" => { page: "2", per: "50" } }, param_name: "t")
        assert_equal "2", table.page_param_value
        assert_equal 50, table.per_page_param_value
      end

      test "total_records_count raises ExtensionRequiredError" do
        table = PaginationTable.new
        assert_raises(RapidUI::ExtensionRequiredError) { table.total_records_count }
      end

      test "total_pages raises ExtensionRequiredError" do
        table = PaginationTable.new
        assert_raises(RapidUI::ExtensionRequiredError) { table.total_pages }
      end

      test "current_page raises ExtensionRequiredError" do
        table = PaginationTable.new
        assert_raises(RapidUI::ExtensionRequiredError) { table.current_page }
      end

      test "per_page and pagination controls are registered" do
        klass = Class.new ViewComponent::Base do
          include Controls::Container
          include Pagination
        end

        assert_registers_control :per_page, klass
        assert_registers_control :pagination, klass
      end
    end
  end
end
