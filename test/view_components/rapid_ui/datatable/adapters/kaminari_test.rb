# frozen_string_literal: true

require "test_helper"

module RapidUI
  module Datatable
    module Adapters
      class KaminariTest < ViewComponentTestCase
        User = Struct.new(:id, :name, :email, keyword_init: true)

        class TestTable < RapidUI::Datatable::Base
          adapter :kaminari
          # self.skip_search = true
          self.skip_sorting = true

          columns do |t|
            t.string :id
            t.string :name
            t.string :email
          end

          def dom_id(record)
            "user_#{record.id}"
          end
        end

        described_class TestTable

        setup do
          skip "Kaminari gem not installed (run with: appraisal kaminari rake test)" unless defined?(::Kaminari)

          @records = [
            User.new(id: 1, name: "Alice", email: "alice@example.com"),
            User.new(id: 2, name: "Bob", email: "bob@example.com"),
            User.new(id: 3, name: "Charlie", email: "charlie@example.com"),
            User.new(id: 4, name: "Diana", email: "diana@example.org"),
            User.new(id: 5, name: "Eve", email: "eve@example.com"),
          ]
          @scope = ::Kaminari.paginate_array(@records)
        end

        test "filter_kaminari returns first page with default per_page" do
          table = build(@scope, id: "t", param_name: :t, full_params: { t: {} })
          assert_equal 5, table.rows.size
          assert_equal @records.map(&:name), table.rows.map(&:name)
        end

        test "filter_kaminari respects per_page param" do
          table = build(@scope, id: "t", param_name: :t, full_params: { t: { per: "2" } })
          assert_equal 2, table.rows.size
          assert_equal %w[Alice Bob], table.rows.map(&:name)
        end

        test "filter_kaminari respects page param" do
          table = build(@scope, id: "t", param_name: :t, full_params: { t: { page: "2", per: "2" } })
          assert_equal 2, table.rows.size
          assert_equal %w[Charlie Diana], table.rows.map(&:name)
        end

        test "total_records_count returns total count from Kaminari" do
          table = build(@scope, id: "t", param_name: :t, full_params: { t: { page: "2", per: "2" } })
          assert_equal 5, table.total_records_count
        end

        test "total_pages is delegated to rows" do
          table = build(@scope, id: "t", param_name: :t, full_params: { t: { per: "2" } })
          assert_equal 3, table.total_pages
        end

        test "current_page is delegated to rows" do
          table = build(@scope, id: "t", param_name: :t, full_params: { t: { page: "2", per: "2" } })
          assert_equal 2, table.current_page
        end

        test "kaminari filter is registered when pagination not skipped" do
          table = build(@scope, id: "t", param_name: :t)
          assert_includes table.class.filter_procs.map(&:first), :kaminari
        end

        test "skip_pagination prevents kaminari filter from being applied" do
          table = build(@scope, id: "t", param_name: :t, skip_pagination: true)
          # With skip_pagination, the kaminari filter is not registered, so unfiltered scope is used
          assert_equal 5, table.rows.size
        end
      end
    end
  end
end
