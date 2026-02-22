# frozen_string_literal: true

require "test_helper"

module RapidUI
  module Datatable
    module Controls
      class PlacementTest < ViewComponentTestCase
        include ExtensionSupport

        class TestSpyComponent < ViewComponent::Base
          attr_reader :build_calls

          def initialize
            super
            @build_calls = []
          end

          def call
            ""
          end
        end

        # Minimal table that includes Placement and has one placement with a spy control.
        # We use a custom controls_class that records build_* calls.
        class PlacementTable < ApplicationComponent
          include RapidUI::Datatable::Controls
          include RapidUI::Datatable::Columns

          column :id

          # Build a controls component that records which build_* methods were called
          renders_one :header, ->(**kwargs) do
            component = build(SpyControlsComponent, table: self, **kwargs)
            component
          end

          controls_placement :header, %i[spy]

          # Register a control that the SpyControlsComponent can handle
          register_control :spy, ->(**kwargs) { TestSpyComponent.new(**kwargs) }

          def initialize(factory: RapidUI::Factory.new, **kwargs)
            super(tag_name: :div, id: nil, data: {}, factory:, **kwargs)
          end

          def skip_spy?
            @skip_spy != false
          end

          attr_writer :skip_spy

          def call
            ""
          end
        end

        # Controls component that records build_spy calls and supports build_group for nested tests
        class SpyControlsComponent < Controls::Component
          attr_reader :build_spy_called, :group_build_spy_called

          def initialize(table:, **kwargs)
            super
            @build_spy_called = false
            @group_build_spy_called = false
          end

          def build_spy(**)
            @build_spy_called = true
          end

          def build_group(**kwargs, &block)
            child = build(self.class, table:, **kwargs)
            block.call(child)
            @group_build_spy_called = child.build_spy_called
          end

          def call
            component_tag { "" }
          end
        end

        setup do
          # Use a table class whose controls_class is SpyControlsComponent so we can assert build_spy was called
          @table_class = Class.new(PlacementTable) do
            define_singleton_method(:controls_class) { PlacementTest::SpyControlsComponent }
          end
        end

        test "controls_placement defines placement attribute (e.g. header_controls)" do
          assert_equal %i[spy], @table_class.header_controls
        end

        test "ensure_header_controls_built sets header when not set and control not skipped" do
          table = @table_class.new
          table.skip_spy = false
          refute table.header

          table.send(:ensure_header_controls_built)

          assert table.header
        end

        test "ensure_header_controls_built does nothing when header already set" do
          table = @table_class.new
          table.skip_spy = false
          table.build_header { |_| }
          header_before = table.header

          table.send(:ensure_header_controls_built)

          assert_same header_before, table.header
        end

        test "ensure_header_controls_built does not set header when all controls skipped" do
          table = @table_class.new
          table.skip_spy = true
          refute table.header

          table.send(:ensure_header_controls_built)

          refute table.header
        end

        test "ensure_header_controls_built invokes build slot and adds controls to component" do
          table = @table_class.new
          table.skip_spy = false

          table.send(:ensure_header_controls_built)

          assert table.header, "header slot should be set"
          # build_controls_on_component is exercised; see test below for direct build_* call assertion
        end

        test "ensure_controls_built runs all placement ensure methods" do
          table = @table_class.new
          table.skip_spy = false

          table.send(:ensure_controls_built)

          assert table.header
        end

        test "skip_control? raises when table does not respond to skip method" do
          table = @table_class.new
          error = assert_raises(ArgumentError) { table.send(:skip_control?, :nonexistent) }
          assert_match(/nonexistent.*skip_nonexistent\?/, error.message)
        end

        test "skip_control? returns false when skip method returns false" do
          table = @table_class.new
          table.skip_spy = false
          refute table.send(:skip_control?, :spy)
        end

        test "skip_control? returns true when skip method returns true" do
          table = @table_class.new
          table.skip_spy = true
          assert table.send(:skip_control?, :spy)
        end

        test "build_controls_on_component raises when component does not respond to build method" do
          table = @table_class.new
          component = SpyControlsComponent.new(table:, factory: table.factory)

          error = assert_raises(ArgumentError) do
            table.send(:build_controls_on_component, component, %i[spy nonexistent])
          end
          assert_match(/nonexistent.*build_nonexistent/, error.message)
          assert component.build_spy_called, "spy should still be built before nonexistent is reached"
        end

        test "nested array in placement wraps controls in a group" do
          table_class_with_group = Class.new(PlacementTable) do
            define_singleton_method(:controls_class) { PlacementTest::SpyControlsComponent }
            controls_placement :header, [ :spy, [ :spy ] ]
          end
          table = table_class_with_group.new
          table.skip_spy = false

          table.send(:ensure_header_controls_built)

          assert table.header, "header should be set"
          assert table.header.build_spy_called, "top-level spy should be built"
          assert table.header.group_build_spy_called, "group should have been built with build_spy (nested array)"
        end
      end
    end
  end
end
