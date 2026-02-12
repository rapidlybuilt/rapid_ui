# frozen_string_literal: true

require "test_helper"

module RapidUI
  class UsesDatatablesTest < ActiveSupport::TestCase
    class EmptyTable < RapidUI::Datatable::Base
      adapter :array
      column :id
    end

    class BasicTable < RapidUI::Datatable::Base
      adapter :array
      column :id
      column :name, searchable: true
    end

    class TestTableWithExtensions < RapidUI::Datatable::Base
      extension :bulk_actions
      extension :export
      extension :select_filters

      adapter :array

      column :id
      column :name, searchable: true

      bulk_action :delete
    end

    class TestController
      include RapidUI::UsesDatatables

      attr_accessor :params

      def ui
        @ui ||= RapidUI::UsesLayout::UI.new(RapidUI::Factory.new, nil)
      end
    end

    setup do
      @controller = TestController.new
      @controller.params = {}

      @records = []
    end

    test "empty datatable doesn't build the header/footer" do
      table = build_datatable(EmptyTable, @records, id: "my-table", skip_pagination: true)
      refute table.header?
      refute table.footer?
    end

    test "basic datatable builds the header/footer" do
      table = build_datatable(BasicTable, @records, id: "my-table")
      assert table.header?
      assert table.footer?
    end

    test "builds datatable w/ all extensions" do
      table = build_datatable(TestTableWithExtensions, @records, id: "my-table")
      assert table.header?
      assert table.footer?
    end

    test "adds the datatables as a renderable component" do
      table = build_datatable(BasicTable, @records, id: "my-table")
      assert_equal [ table ], @controller.send(:renderable_components).values
    end

    def build_datatable(*args, **kwargs, &)
      @controller.send(:build_datatable, *args, **kwargs, &)
    end
  end
end
