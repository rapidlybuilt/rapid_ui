# frozen_string_literal: true

require "test_helper"

module RapidUI
  module Datatable
    module Extensions
      class SelectFiltersTest < ViewComponentTestCase
        include ExtensionSupport
        described_class SelectFilters::Component

        class SelectFilterTable < ExtensionSupport::TestComponent
          include SelectFilters

          select_filter :status,
            choices: ->(scope) { %w[active archived] },
            filter: ->(scope, val) { scope.select { |s| s == val } }

          def unfiltered_rows
            %w[active archived]
          end

          def table_path(**options)
            "/?#{options.to_query}"
          end
        end

        class ChildSelectFilterTable < SelectFilterTable
          select_filter :child,
            choices: ->(scope) { %w[foo bar] },
            filter: ->(scope, val) { scope.select { |s| s == val } }
        end

        setup do
          @scope = %w[active archived]
          @status_definition = SelectFilterTable.find_select_filter_definition(:status)
          @child_definition = ChildSelectFilterTable.find_select_filter_definition(:child)
        end

        test "skip_select_filters? is true when no select filters are defined" do
          refute SelectFilterTable.new.skip_select_filters?
        end

        test "skip_select_filters? is false when select filters are defined" do
          klass = Class.new { include SelectFilters }
          assert klass.new.skip_select_filters?
        end

        test "apply filter when param is present" do
          table = SelectFilterTable.new(full_params: { status_filter: "active" })
          assert_equal [ "active" ], table.rows
        end

        test "doesn't apply filters when skipping the specific filter" do
          table = SelectFilterTable.new(full_params: { status_filter: "active" })
          table.skip_status_filter = true
          assert_equal @scope, table.rows
        end

        test "doesn't apply filters when param is blank" do
          table = SelectFilterTable.new(full_params: {})
          assert_equal @scope, table.rows
        end

        test "inherits select_filter definitions from parent" do
          assert_equal [ :status ], SelectFilterTable.select_filter_definitions.map { |s| s[:filter_id] }
          assert_equal [ :status, :child ], ChildSelectFilterTable.select_filter_definitions.map { |s| s[:filter_id] }
        end

        test "renders a select with datatable filter classes" do
          table = SelectFilterTable.new
          render_inline(build(@status_definition, table: table))

          assert_selector "select.datatable-select.datatable-filter-select"
        end

        test "includes All option with label from locale" do
          table = SelectFilterTable.new
          render_inline(build(@status_definition, table: table))

          option = page.find("option", text: "All Statuses")
          # Accept both forms: nil may be serialized as "status_filter=" or omitted (Rails/Ruby version-dependent)
          assert_includes [ "/?status_filter", "/?status_filter=" ], option[:value]
        end

        test "includes choices from choices proc" do
          table = SelectFilterTable.new
          render_inline(build(@status_definition, table: table))

          assert_selector "option[value='/?status_filter=active']", text: "active"
          assert_selector "option[value='/?status_filter=archived']", text: "archived"
        end

        test "select name uses table param_name when set" do
          table = SelectFilterTable.new(param_name: :t)
          render_inline(build(@status_definition, table: table))

          assert_selector "select[name='t[status_filter]']"
        end

        test "marks option as selected when filter param is present" do
          table = SelectFilterTable.new(full_params: { status_filter: "active" })
          render_inline(build(@status_definition, table: table))

          assert_selector "option[value='/?status_filter=active'][selected]", text: "active"
        end

        test "assigns filter_id and table" do
          table = SelectFilterTable.new
          component = build(@status_definition, table: table)
          assert_equal :status, component.filter_id
          assert_equal table, component.table
        end

        test "select_filter control is registered" do
          klass = Class.new ViewComponent::Base do
            include Controls
            include SelectFilters
          end

          assert_registers_control :select_filter, klass
        end

        test "select_filter is prepended to the filter procs to avoid filtering after pagination" do
          klass = Class.new ViewComponent::Base do
            include SelectFilters
            register_filter :pagination
            select_filter :status, choices: ->(scope) { }, filter: ->(scope, val) { }
          end

          assert_equal [ :select_filter_status, :pagination ], klass.filter_procs.map { |s| s[0] }
        end
      end
    end
  end
end
