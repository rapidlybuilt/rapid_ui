# frozen_string_literal: true

require_relative "../../view_component_test_case"

module RapidUI
  module Datatable
    module Support
      class RegisterProcsTest < ViewComponent::TestCase
        class TestTable < ExtensionSupport::TestComponent
          include RegisterProcs

          def filtered_scope(scope)
            apply_filters(scope)
          end
        end

        setup do
          @subclass = Class.new(TestTable)
        end

        test "register_initializer with block is called with self and config" do
          received_self = received_config = nil

          @subclass.class_eval do
            register_initializer(:test_init) do |t, config|
              received_self = t
              received_config = config
            end
          end

          table = @subclass.new
          assert_same table, received_self
          assert_same table.config, received_config
        end

        test "register_initializer without block calls initialize_<id>(config)" do
          @subclass.class_eval do
            register_initializer :custom

            attr_accessor :received_config
            def initialize_custom(config)
              @received_config = config
            end
          end

          table = @subclass.new
          assert_same table.config, table.received_config
        end

        test "register_initializer with after: runs after named proc" do
          order = []
          table_class = Class.new(ExtensionSupport::TestComponent) do
            include RegisterProcs
            register_initializer(:first) { |_, _| order << :first }
            register_initializer(:second, after: :first) { |_, _| order << :second }
          end
          table_class.new
          assert_equal [ :first, :second ], order
        end

        test "register_initializer with before: runs before named proc" do
          order = []
          table_class = Class.new(ExtensionSupport::TestComponent) do
            include RegisterProcs
            register_initializer(:second) { |_, _| order << :second }
            register_initializer(:first, before: :second) { |_, _| order << :first }
          end
          table_class.new
          assert_equal [ :first, :second ], order
        end

        test "register_filter applies filter to scope" do
          table_class = Class.new(TestTable) do
            register_filter(:double) { |_table, scope| scope * 2 }
          end
          table = table_class.new
          result = table.filtered_scope(5)
          assert_equal 10, result
        end

        test "apply_filters with Proc scope calls scope first" do
          table_class = Class.new(TestTable) do
            register_filter(:add_one) { |_table, scope| scope + 1 }
          end
          table = table_class.new
          result = table.filtered_scope(-> { 10 })
          assert_equal 11, result
        end

        test "filter with if: skips when condition is false" do
          table_class = Class.new(TestTable) do
            attr_accessor :filter_enabled
            register_filter(:maybe_double, if: :filter_enabled) { |_table, scope| scope * 2 }
          end
          table = table_class.new
          table.filter_enabled = false
          assert_equal 5, table.filtered_scope(5)
          table.filter_enabled = true
          assert_equal 10, table.filtered_scope(5)
        end

        test "filter with unless: skips when condition is true" do
          table_class = Class.new(TestTable) do
            attr_accessor :filter_skipped
            register_filter(:maybe_double, unless: :filter_skipped) { |_table, scope| scope * 2 }
          end
          table = table_class.new
          table.filter_skipped = true
          assert_equal 5, table.filtered_scope(5)
          table.filter_skipped = false
          assert_equal 10, table.filtered_scope(5)
        end

        test "subclass inherits and can extend initializer_procs" do
          parent_class = Class.new do
            include RegisterProcs
            register_initializer(:parent) { |t, _| t.instance_variable_set(:@parent_ran, true) }
          end
          child_class = Class.new(parent_class) do
            register_initializer(:child) { |t, _| t.instance_variable_set(:@child_ran, true) }
          end
          table = child_class.new
          table.send(:apply_initializers, {})
          assert table.instance_variable_get(:@parent_ran)
          assert table.instance_variable_get(:@child_ran)
        end

        test "find_proc_index! raises for unknown proc" do
          table_class = Class.new do
            include RegisterProcs
          end
          error = assert_raises(ArgumentError) do
            table_class.register_initializer(:missing, after: :nonexistent) { }
          end
          assert_includes error.message, "nonexistent"
        end
      end
    end
  end
end
