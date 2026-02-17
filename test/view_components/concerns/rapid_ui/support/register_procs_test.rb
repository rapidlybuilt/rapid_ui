# frozen_string_literal: true

require "test_helper"

module RapidUI
  module Support
    class RegisterProcsTest < ActiveSupport::TestCase
      class Test
        include RegisterProcs
        def_registered_procs :filters
      end

      setup do
        @subclass = Class.new(Test)
      end

      test "def_registered_procs defines name_procs method returning an array" do
        assert_respond_to Test, :filters_procs
        assert_equal [], Test.filters_procs
      end

      test "def_registered_procs defines register_name method" do
        assert_respond_to Test, :register_filters
      end

      test "register_filters adds proc to filters_procs" do
        @subclass.class_eval do
          register_filters(:double) { |_obj, x| x * 2 }
        end
        assert_equal 1, @subclass.filters_procs.size
        assert_equal :double, @subclass.filters_procs.first[0]
      end

      test "register_filters with prepend: adds proc to beginning of filters_procs" do
        @subclass.class_eval do
          include RegisterProcs
          def_registered_procs :steps
          register_steps(:first) { |_, _| order << :first }
          register_steps(:second, prepend: true) { |_, _| order << :second }
        end
        assert_equal 2, @subclass.steps_procs.size
        assert_equal :second, @subclass.steps_procs.first[0]
        assert_equal :first, @subclass.steps_procs.last[0]
      end

      test "register_filters with after: runs after named proc" do
        order = []
        table_class = Class.new do
          include RegisterProcs
          def_registered_procs :steps
          register_steps(:first) { |_, _| order << :first }
          register_steps(:second, after: :first) { |_, _| order << :second }
        end
        table = table_class.new
        table_class.steps_procs.each { |(id, block, opts)| table.send(:apply_proc, id, [ id, block, opts ], nil) }
        assert_equal [ :first, :second ], order
      end

      test "register_filters with before: runs before named proc" do
        order = []
        table_class = Class.new do
          include RegisterProcs
          def_registered_procs :steps
          register_steps(:second) { |_, _| order << :second }
          register_steps(:first, before: :second) { |_, _| order << :first }
        end
        table = table_class.new
        table_class.steps_procs.each { |(id, block, opts)| table.send(:apply_proc, id, [ id, block, opts ], nil) }
        assert_equal [ :first, :second ], order
      end

      test "subclass inherits procs and can extend without affecting superclass" do
        parent_class = Class.new do
          include RegisterProcs
          def_registered_procs :hooks
          register_hooks(:parent) { |t, _| t.instance_variable_set(:@parent_ran, true) }
        end
        child_class = Class.new(parent_class) do
          register_hooks(:child) { |t, _| t.instance_variable_set(:@child_ran, true) }
        end
        assert_equal 1, parent_class.hooks_procs.size
        assert_equal 2, child_class.hooks_procs.size
        assert_equal [ :parent ], parent_class.hooks_procs.map(&:first)
        assert_equal [ :parent, :child ], child_class.hooks_procs.map(&:first)
      end

      test "apply_proc with block calls block with self and args" do
        received_self = received_arg = nil
        @subclass.class_eval do
          register_filters(:capture) do |obj, arg|
            received_self = obj
            received_arg = arg
          end
        end
        table = @subclass.new
        proc_entry = @subclass.filters_procs.first
        table.send(:apply_proc, :capture, proc_entry, 42)
        assert_same table, received_self
        assert_equal 42, received_arg
      end

      test "apply_proc without block sends id_proc0 with args" do
        @subclass.class_eval do
          register_filters :custom
          attr_accessor :received_arg
          define_method(:custom_custom) { |arg| self.received_arg = arg }
        end
        table = @subclass.new
        proc_entry = @subclass.filters_procs.first
        table.send(:apply_proc, :custom, proc_entry, 99)
        assert_equal 99, table.received_arg
      end

      test "apply_proc with if: skips when condition is false" do
        ran = false
        table_class = Class.new do
          include RegisterProcs
          def_registered_procs :filters
          attr_accessor :enabled
          register_filters(:maybe_double, if: :enabled) { |_, _| ran = true }
        end
        table = table_class.new
        table.enabled = false
        proc_entry = table_class.filters_procs.first
        table.send(:apply_proc, :maybe_double, proc_entry, 5)
        assert_not ran, "block should not run when if: is false"
        table.enabled = true
        table.send(:apply_proc, :maybe_double, proc_entry, 5)
        assert ran, "block should run when if: is true"
      end

      test "apply_proc with unless: skips when condition is true" do
        ran = false
        table_class = Class.new do
          include RegisterProcs
          def_registered_procs :filters
          attr_accessor :skip
          register_filters(:maybe_run, unless: :skip) { |_, _| ran = true }
        end
        table = table_class.new
        table.skip = true
        proc_entry = table_class.filters_procs.first
        table.send(:apply_proc, :maybe_run, proc_entry, 5)
        assert_not ran, "block should not run when unless: is true"
        table.skip = false
        table.send(:apply_proc, :maybe_run, proc_entry, 5)
        assert ran, "block should run when unless: is false"
      end

      test "register_filters with after: unknown id raises ArgumentError" do
        table_class = Class.new do
          include RegisterProcs
          def_registered_procs :filters
        end
        error = assert_raises(ArgumentError) do
          table_class.register_filters(:missing, after: :nonexistent) { }
        end
        assert_includes error.message, "nonexistent"
      end

      test "raise an error if the proc name has already been registered" do
        table_class = Class.new do
          include RegisterProcs
          def_registered_procs :filters
        end
        table_class.register_filters(:double) { |_obj, x| x * 2 }
        assert_raises(ArgumentError) do
          table_class.register_filters(:double) { |_obj, x| x * 2 }
        end
      end
    end
  end
end
