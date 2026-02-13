# frozen_string_literal: true

require "test_helper"

module RapidUI
  module Datatable
    module Support
      class LoadersTest < ActiveSupport::TestCase
        test "load_adapter loads the adapter" do
          klass = Class.new do
            include Loaders
            adapter :array
          end
          assert_includes klass.included_modules, Adapters::Array
        end

        test "load_extension loads the extension" do
          klass = Class.new do
            include Loaders
            extension :export
          end
          assert_includes klass.included_modules, Extensions::Export
        end
      end
    end
  end
end
