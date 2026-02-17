# frozen_string_literal: true

require "test_helper"

module RapidUI
  module Datatable
    class ControlsTest < ViewComponentTestCase
      include ExtensionSupport
      described_class Controls::Component

      class TestControl < ViewComponent::Base
        attr_accessor :name

        def initialize(name)
          @name = name
        end

        def call
          tag.span(name, class: "child")
        end
      end

      class ControlsTable < ViewComponent::Base
        include Controls
        include Columns

        column :id
        column :name

        renders_one :header, ->(**kwargs) do
          self.class.controls_class.new(table: self, factory: Factory.new, **kwargs)
        end

        def call
          safe_join([ header ])
        end
      end

      class SubclassControlsTable < ControlsTable
        register_control :test, ->(name) { TestControl.new(name) }
      end

      test "renders an empty div when no items are added" do
        table = ControlsTable.new
        render_inline(build(table: table))
        assert_selector "div", text: ""
      end

      test "control groups with buttons" do
        table = ControlsTable.new
        render_inline build(table: table) do |c|
          c.with_group(class: "test-group") do |g|
            g.with_tag(:button, "Test Button1")
            g.with_tag(:button, "Test Button2")
          end
        end
        assert_selector "div.test-group button", text: "Test Button1"
        assert_selector "div.test-group button", text: "Test Button2"
      end

      test "child class registers a new control" do
        render_inline SubclassControlsTable.new do |t|
          t.with_header do |header|
            header.with_test("testing")
          end
        end
        assert_selector "div span.child", text: "testing"
      end

      test "doesn't register on parent class" do
        refute_registers_control :test, ControlsTable
      end
    end
  end
end
