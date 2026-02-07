# frozen_string_literal: true

require_relative "../../view_component_test_case"

module RapidUI
  module Datatable
    module Support
      class ConfigAttributeTest < ViewComponent::TestCase
        class TestTable
          include ConfigAttribute
          config_attribute :per_page, default: 25
        end

        class BooleanTestTable
          include ConfigAttribute
          config_attribute :skip_search, default: false, boolean: true
        end

        class ChildTestTable < TestTable
          self.per_page = 50
        end

        test "class has default value" do
          assert_equal 25, TestTable.per_page
        end

        test "instance delegates to config with class default when not overridden" do
          assert_equal 25, TestTable.new.per_page
        end

        test "instance uses override when passed" do
          table = TestTable.new(per_page: 100)
          assert_equal 100, table.per_page
        end

        test "child class overrides parent class" do
          assert_equal 50, ChildTestTable.per_page
          assert_equal 25, TestTable.per_page

          assert_equal 50, ChildTestTable.new.per_page
          assert_equal 25, TestTable.new.per_page
        end

        test "boolean config attribute" do
          assert_equal false, BooleanTestTable.new.skip_search?
          assert_equal true, BooleanTestTable.new(skip_search: true).skip_search?
        end
      end
    end
  end
end
