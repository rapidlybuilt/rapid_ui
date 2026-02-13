require "test_helper"

module RapidUI
  module Datatable
    module Support
      class HasStimulusControllerTest < ViewComponent::TestCase
        class TestTable < ExtensionSupport::TestComponent
          include HasStimulusController
        end

        test "stimulus_controller defaults to 'datatable'" do
          table = TestTable.new
          assert_equal "datatable", table.stimulus_controller.name
        end
      end
    end
  end
end
