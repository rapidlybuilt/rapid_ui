# frozen_string_literal: true

require "test_helper"

module RapidUI
  module Support
    class ExtendableClassTest < ActiveSupport::TestCase
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

      class SubclassTable < TableWithItem
      end

      test "build from hash sets attributes" do
        item = TableWithItem.build_item(id: 1, name: "Alice")
        assert_equal 1, item.id
        assert_equal "Alice", item.name
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
        error = assert_raises(ArgumentError) { bare_class.find_extendable_class!(:item) }
        assert_includes error.message, "item"
      end

      test "build with wrong number of arguments raises" do
        assert_raises(ArgumentError) { TableWithItem.build_item("not a hash") }
      end

      test "creates an extendable subclass in the subclass if it's extended" do
        assert_equal TableWithItem.item_class, AdminTable.item_class.superclass
      end

      test "doesn't create an extendable subclass in the subclass if it's not extended" do
        assert_equal TableWithItem.item_class, SubclassTable.item_class
      end

      class SuperclassTest < ActiveSupport::TestCase
        class MySuperclass < RapidUI::Support::ExtendableClass::Base
          attr_accessor :name

          def initialize(**options)
            @name = "set"
            super(**options)
          end
        end

        class MyTest
          include ExtendableClass
          def_extendable_class :item, superclass: MySuperclass
        end

        test "defines a subclass of the superclass" do
          instance = MyTest.build_item(name: "x")
          assert_equal "x", instance.name

          assert_instance_of MyTest.item_class, instance
          assert MySuperclass, MyTest.item_class.superclass
        end

        test "runs the superclass initializer" do
          assert_equal "set", MyTest.build_item.name
        end

        test "accepts settable attributes in the initializer" do
          assert_equal "x", MyTest.build_item(name: "x").name
        end
      end
    end
  end
end
