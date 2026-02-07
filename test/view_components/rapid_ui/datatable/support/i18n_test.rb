# frozen_string_literal: true

require_relative "../../view_component_test_case"

module RapidUI
  module Datatable
    module Support
      class I18nTest < ViewComponent::TestCase
        include I18nSupport

        class UsersTable
          include I18n
        end

        test "table_name accessor" do
          table = UsersTable.new
          table.table_name = "users"
          assert_equal "users", table.table_name
        end

        test "class table_name returns underscored name" do
          assert_equal "rapid_ui/datatable/support/i18n_test/users_table", UsersTable.table_name
        end

        test "instance t joins keys and delegates to class t with table_name" do
          table = UsersTable.new
          table.table_name = "users"
          mock_translation("rapid_ui.datatable.users.empty_message", "No records")
          assert_equal "No records", table.t("empty_message")
        end

        test "instance t with multiple keys joins with dot" do
          table = UsersTable.new
          table.table_name = "users"
          mock_translation("rapid_ui.datatable.users.pagination.prev", "Previous")
          assert_equal "Previous", table.t("pagination", "prev")
        end
      end
    end
  end
end
