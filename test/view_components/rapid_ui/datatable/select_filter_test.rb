# frozen_string_literal: true

require_relative "../view_component_test_case"

module RapidUI
  module Datatable
    class SelectFilterTest < ViewComponentTestCase
      described_class SelectFilter

      class SelectFilterTable < ViewComponent::Base
        include Support::Params
        include Support::Hotwire
        include SelectFilter::Container

        select_filter :status, options: ->(scope) { scope }, filter: ->(scope, val) { scope.select { |s| s == val } }

        def call
          ""
        end

        def base_scope
          %w[active archived]
        end

        def table_path(**options)
          "/?#{options.to_query}"
        end
      end

      class ChildSelectFilterTable < SelectFilterTable
        select_filter :child, options: ->(scope) { scope }, filter: ->(scope, val) { scope.select { |s| s == val } }
      end

      setup do
        @scope = %w[active archived]
        @options = ->(s) { %w[active archived] }
        @filter = ->(s, v) { raise "filter called with #{s} and #{v}" }
      end

      test "filter_select_filters applies filter proc when param is present" do
        table = SelectFilterTable.new(params: { status_filter: "active" })
        table.stimulus_controller = "datatable"

        result = table.send(:filter_select_filters, @scope)

        assert_equal ["active"], result
      end

      test "filter_select_filters returns scope unchanged when param is blank" do
        table = SelectFilterTable.new(params: {})
        table.stimulus_controller = "datatable"

        result = table.send(:filter_select_filters, @scope)

        assert_equal @scope, result
      end

      test "inherits select_filter definitions from parent" do
        assert_equal [:status], SelectFilterTable.select_filter_definitions.map { |s| s[:filter_id] }
        assert_equal [:status, :child], ChildSelectFilterTable.select_filter_definitions.map { |s| s[:filter_id] }
      end

      test "renders a select with datatable filter classes" do
        table = SelectFilterTable.new
        table.stimulus_controller = "datatable"
        render_inline(build(filter_id: :status, options: @options, filter: @filter, table: table))

        assert_selector "select.datatable-select.datatable-filter-select"
      end

      test "includes All option with label from locale" do
        table = SelectFilterTable.new
        table.stimulus_controller = "datatable"
        render_inline(build(filter_id: :status, options: @options, filter: @filter, table: table))

        assert_selector "select" do
          assert_selector "option[value='/?status_filter=']", text: "All Statuses"
        end
      end

      test "includes options from options proc" do
        table = SelectFilterTable.new
        table.stimulus_controller = "datatable"
        render_inline(build(filter_id: :status, options: @options, filter: @filter, table: table))

        assert_selector "option[value='/?status_filter=active']", text: "active"
        assert_selector "option[value='/?status_filter=archived']", text: "archived"
      end

      test "select name uses table param_name when set" do
        table = SelectFilterTable.new(param_name: :t)
        table.stimulus_controller = "datatable"
        render_inline(build(filter_id: :status, options: @options, filter: @filter, table: table))

        assert_selector "select[name='t[status_filter]']"
      end

      test "marks option as selected when filter param is present" do
        table = SelectFilterTable.new(params: { status_filter: "active" })
        table.stimulus_controller = "datatable"
        render_inline(build(filter_id: :status, options: @options, filter: @filter, table: table))

        assert_selector "option[value='/?status_filter=active'][selected]", text: "active"
      end

      test "assigns filter_id and table" do
        table = SelectFilterTable.new
        component = build(filter_id: :status, options: @options, filter: @filter, table: table)
        assert_equal :status, component.filter_id
        assert_equal table, component.table
      end
    end
  end
end
