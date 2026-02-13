# frozen_string_literal: true

require_relative "../../view_component_test_case"

module RapidUI
  module Datatable
    module Support
      class HasPersistentParamsTest < ViewComponent::TestCase
        class TestTable < ExtensionSupport::TestComponent
          include HasPersistentParams
          class_attribute :page_param, default: :page
          persistent_param :page_param
        end

        test "params returns nested hash when param_name is set" do
          table = TestTable.new(
            param_name: :users,
            full_params: { users: { page: "2" } }
          )
          assert_equal({ page: "2" }, table.params)
        end

        test "params returns full_params when param_name not set" do
          table = TestTable.new(full_params: { page: "1" })
          assert_equal({ page: "1" }, table.params)
        end

        test "params returns empty hash when no params" do
          table = TestTable.new
          assert_equal({}, table.params)
        end

        test "id_for prefixes with param_name when set" do
          table = TestTable.new(param_name: :users)
          assert_equal "users_search", table.id_for(:search)
        end

        test "id_for returns name when param_name not set" do
          table = TestTable.new
          assert_equal :search, table.id_for(:search)
        end

        test "param_name with nested name returns bracketed form when param_name set" do
          table = TestTable.new(param_name: :users)
          assert_equal "users[page]", table.param_name(:page)
        end

        test "param_name with nested name returns name when param_name not set" do
          table = TestTable.new
          assert_equal :page, table.param_name(:page)
        end

        test "param_name with no arg returns param_name or nil" do
          table = TestTable.new(param_name: :users)
          assert_equal :users, table.param_name
          table = TestTable.new
          assert_nil table.param_name
        end

        test "persist_param_name and persistent_param_names" do
          table = MinimalTable.new
          assert_equal [], table.persistent_param_names

          table.persist_param_name(:page, :sort)
          assert_includes table.persistent_param_names, :page
          assert_includes table.persistent_param_names, :sort
        end

        test "persistent_params slices params by registered names" do
          table = TestTable.new(full_params: { users: { page: "2", sort: "name", other: "x" } }, param_name: :users)
          table.persist_param_name(:page, :sort)
          assert_equal({ page: "2", sort: "name" }, table.persistent_params)
        end

        test "persistent_params with overrides merges" do
          table = TestTable.new(full_params: { users: { page: "1" } }, param_name: :users)
          table.persist_param_name("page")
          assert_equal({ page: 3 }, table.persistent_params(page: 3))
        end

        test "hidden_fields_of_persistent_params renders hidden inputs" do
          table = TableComponent.new(full_params: { users: { page: "2" } }, param_name: :users)
          render_inline(table)

          html = table.hidden_fields_of_persistent_params
          assert_includes html, 'name="users[page]"'
          assert_includes html, 'value="2"'
        end
      end

      # No persistent_params so we can test empty persistent_param_names
      class MinimalTable
        include HasPersistentParams
      end

      # ViewComponent so it gets view_context when rendered (needed for hidden_field_tag)
      class TableComponent < ExtensionSupport::TestComponent
        include HasPersistentParams
        class_attribute :page_param, default: :page
        persistent_param :page_param
      end
    end
  end
end
