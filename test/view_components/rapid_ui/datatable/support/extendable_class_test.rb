# frozen_string_literal: true

require_relative "../../view_component_test_case"

module RapidUI
  module Datatable
    module Support
      class ExtendableClassTest < ViewComponent::TestCase
        class TableWithItem
          include ExtendableClass

          def_extendable_class :item do
            attr_accessor :id
            attr_accessor :name
          end
        end

        class AdminTable < TableWithItem
          item_class! do
            attr_accessor :role
          end
        end

        test "build from hash sets attributes" do
          item = TableWithItem.build_item(id: 1, name: "Alice")
          assert_equal 1, item.id
          assert_equal "Alice", item.name
        end

        test "build_plural from array of hashes" do
          items = TableWithItem.build_items([ { id: 1, name: "A" }, { id: 2, name: "B" } ])
          assert_equal 2, items.size
          assert_equal 1, items[0].id
          assert_equal "A", items[0].name
          assert_equal 2, items[1].id
        end

        test "passing same class instance returns it" do
          item = TableWithItem.build_item(id: 1, name: "x")
          assert_same item, TableWithItem.build_item(item)
        end

        test "to_h returns attribute hash" do
          item = TableWithItem.build_item(id: 1, name: "x")
          assert_equal({ id: 1, name: "x" }, item.to_h)
        end

        test "becomes builds new instance of target class with same attributes" do
          item = TableWithItem.build_item(id: 1, name: "x")
          admin_item = item.becomes(AdminTable.item_class)
          assert_instance_of AdminTable.item_class, admin_item
          assert_equal 1, admin_item.id
          assert_equal "x", admin_item.name
        end

        test "becomes raises when target is not subclass" do
          item = TableWithItem.build_item(id: 1, name: "x")
          error = assert_raises(ArgumentError) { item.becomes(ExtendableClass::Base) }
          assert_includes error.message, "not a subclass"
        end

        test "find_extendable_class returns class when defined" do
          item_klass = TableWithItem.find_extendable_class(:item)
          assert_not_nil item_klass
          assert_instance_of item_klass, TableWithItem.build_item(id: 1, name: "x")
          assert_equal item_klass, AdminTable.find_extendable_class(:item).superclass
        end

        test "find_extendable_class! raises when not found" do
          bare_class = Class.new
          bare_class.include(ExtendableClass)
          error = assert_raises(RapidUI::ExtendableClassNotFoundError) { bare_class.find_extendable_class!(:item) }
          assert_includes error.message, "item"
        end

        test "build with wrong type raises" do
          error = assert_raises(ArgumentError) { TableWithItem.build_item("not a hash") }
          assert_includes error.message, "must be"
        end
      end
    end
  end
end
