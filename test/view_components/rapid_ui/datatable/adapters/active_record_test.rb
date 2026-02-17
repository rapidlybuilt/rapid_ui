# frozen_string_literal: true

require "test_helper"

# Uses test/support/activerecord_support.rb (in-memory SQLite, BlogPost model).
# Run with: bundle exec appraisal activerecord-8.1 rake test
module RapidUI
  module Datatable
    module Adapters
      class ActiveRecordTest < ViewComponentTestCase
        class TestTable < RapidUI::Datatable::Base
          adapter :active_record

          columns do |t|
            t.string :id
            t.string :title, sortable: true, searchable: true
            t.string :author_name, sortable: true, searchable: true
            t.string :body, sortable: true, searchable: true
          end

          def dom_id(record)
            "blog_post_#{record.respond_to?(:id) ? record.id : record[:id]}"
          end
        end

        described_class TestTable

        setup do
          skip "ActiveRecord not in bundle (run with: appraisal activerecord-8.1 rake test)" unless defined?(::ActiveRecord)

          @alpha = BlogPost.create!(title: "Alpha",  author_name: "Alice",   body: "First post.")
          @beta  = BlogPost.create!(title: "Beta",   author_name: "Bob",     body: "Second post.")
          @gamma = BlogPost.create!(title: "Gamma",  author_name: "Charlie", body: "Third post.")
        end

        teardown do
          BlogPost.delete_all if defined?(BlogPost)
        end

        test "each_row calls find_each and yields each row with correct batch_size" do
          table = build(BlogPost.all, id: "t", param_name: :t, full_params: { t: {} })
          yielded = []
          table.each_row(batch_size: 500) { |row| yielded << row }

          assert_equal 3, yielded.size
          assert_equal [ @alpha.id, @beta.id, @gamma.id ], yielded.map(&:id).sort
        end

        test "row_id returns primary key value from record" do
          table = build(BlogPost.all, id: "t", param_name: :t, full_params: { t: {} })
          assert_equal @alpha.id, table.row_id(@alpha)
          assert_equal @beta.id, table.row_id(@beta)
        end

        test "filter_sorting applies reorder and order by column and direction" do
          table = build(BlogPost.all, id: "t", param_name: :t, full_params: { t: { sort: "title", dir: "desc" } })
          rows = table.rows.to_a

          assert_equal 3, rows.size
          assert_equal %w[Gamma Beta Alpha], rows.map(&:title), "expected sort title desc"
        end

        test "filter_search applies scope.search with search_query" do
          table = build(BlogPost.all, id: "t", param_name: :t, full_params: { t: { q: "alice" } })
          rows = table.rows.to_a

          assert_equal 1, rows.size
          assert_equal "Alice", rows.first.author_name
          assert_equal "Alpha", rows.first.title
        end

        test "filter_sorting_nulls_last orders nulls last" do
          table_class = Class.new(TestTable) do
            columns do |t|
              t.string :id
              t.string :title, sortable: true, nulls_last: true
              t.string :author_name, sortable: true
              t.string :body, sortable: true
            end
          end

          # One post with nil title
          BlogPost.where(id: @gamma.id).update_all(title: nil)

          table = table_class.new(
            BlogPost.all,
            id: "t",
            param_name: :t,
            factory: factory,
            full_params: { t: { sort: "title", dir: "asc" } }
          )
          rows = table.rows.to_a
          assert_equal 3, rows.size
          # Alpha, Beta (non-null), then Gamma (null title)
          assert_equal "Alpha", rows[0].title
          assert_equal "Beta",  rows[1].title
          assert_nil rows[2].title
        end

        test "filter_sorting_nulls_last raises ArgumentError for invalid sort_order" do
          table_class = Class.new(TestTable) do
            columns do |t|
              t.string :id
              t.string :title, sortable: true, nulls_last: true
              t.string :author_name
              t.string :body
            end
          end

          table = table_class.new(
            BlogPost.all,
            id: "t",
            param_name: :t,
            factory: factory,
            full_params: { t: { sort: "title", dir: "asc" } }
          )
          table.sort_column = table.columns.find { |c| c.id == :title }
          table.sort_column.nulls_last = true
          table.sort_order = "invalid"

          assert_raises(ArgumentError) do
            table.filter_sorting(table.unfiltered_rows)
          end
        end
      end
    end
  end
end
