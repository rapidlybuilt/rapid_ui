require "test_helper"

module RapidUI
  module Datatable
    module Support
      class HotwireTest < ViewComponent::TestCase
        class TestTable < ExtensionSupport::TestComponent
          include Hotwire
        end

        test "stimulus_controller defaults to 'datatable'" do
          table = TestTable.new
          assert_equal "datatable", table.stimulus_controller
        end
      end
    end
  end
end
