require_relative "view_component_test_case"

module RapidUI
  class ApplicationComponentTest < ViewComponentTestCase
    described_class ApplicationComponent

    test "raising an error on random keyword arguments" do
      assert_raises ArgumentError do
        build(random: "argument")
      end
    end
  end
end
