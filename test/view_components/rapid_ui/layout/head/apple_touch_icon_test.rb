require_relative "../../view_component_test_case"

module RapidUI
  module Layout
    module Head
      class AppleTouchIconTest < ViewComponentTestCase
        described_class AppleTouchIcon

        test "generates an apple touch icon link" do
          vc_test_view_context.stub(:image_path, "/assets/apple-touch-icon.png") do
            render_inline build("apple-touch-icon.png")
            assert_equal %(<link rel="apple-touch-icon" href="/assets/apple-touch-icon.png">), rendered_content
          end
        end
      end
    end
  end
end
