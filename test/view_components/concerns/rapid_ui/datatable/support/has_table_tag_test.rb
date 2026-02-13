# frozen_string_literal: true

require "test_helper"

module RapidUI
  module Datatable
    module Support
      class HasTableTagTest < ViewComponent::TestCase
        class TestComponent < ExtensionSupport::TestComponent
          include HasTableTag

          with_options to: :RapidUI do
            delegate :merge_classes
          end

          def call
            table_tag(class: "custom") { "content" }
          end
        end

        test "table_tag renders a table with base table class" do
          component = TestComponent.new
          html = component.table_tag { "body" }
          assert_includes html, "<table"
          assert_includes html, 'class="table"'
        end

        test "table_tag merges custom class from kwargs" do
          component = TestComponent.new
          html = component.table_tag(class: "custom")
          assert_includes html, 'class="table custom"'
        end

        test "table_tag with striped adds table-striped" do
          component = TestComponent.new(striped: true)
          html = component.table_tag { "body" }
          assert_includes html, "table-striped"
        end

        test "table_tag with align adds table-align class" do
          component = TestComponent.new(align: "middle")
          html = component.table_tag { "body" }
          assert_includes html, "table-align-middle"
        end

        test "thead_row_tag renders a tr" do
          component = TestComponent.new
          html = component.thead_row_tag { "cells" }
          assert_includes html, "<tr"
          assert_includes html, "cells"
        end

        test "table_tag when responsive wraps table in div with table-responsive" do
          component = TestComponent.new(responsive: true)
          html = component.table_tag { "body" }
          assert_includes html, '<div class="table-responsive">'
          assert_includes html, "<table"
        end

        test "table_tag when responsive is string uses table-responsive-{value}" do
          component = TestComponent.new(responsive: "md")
          html = component.table_tag { "body" }
          assert_includes html, 'class="table-responsive-md"'
        end

        test "table_tag when not responsive returns table only" do
          component = TestComponent.new
          html = component.table_tag { "body" }
          refute_includes html, "table-responsive"
          assert_includes html, "<table"
        end
      end
    end
  end
end
