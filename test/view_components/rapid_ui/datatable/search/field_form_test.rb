# frozen_string_literal: true

require_relative "../../view_component_test_case"

module RapidUI
  module Datatable
    module Search
      class FieldFormTest < ViewComponentTestCase
        described_class FieldForm

        class SearchTable < ExtensionSupport::TestComponent
          include Search
          def call ; end
        end

        test "renders input with param name and placeholder" do
          table = SearchTable.new(param_name: :users, params: { users: { q: "test" } })
          render_inline(build(table:, url: "/search"))

          assert_selector "form[action='/search'][method='get'][data-turbo-stream]" do
            assert_selector "input[name='users[q]'][value='test'][placeholder='Search...']"
          end
        end
      end
    end
  end
end
