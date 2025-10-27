require_relative "../../view_component_test_case"

module RapidUI
  module Layout
    module Head
      class FaviconTest < ViewComponentTestCase
        described_class Favicon

        test "generates a favicon link" do
          vc_test_view_context.stub(:image_path, "/assets/favicon.ico") do
            render_inline build("favicon.ico", type: "image/x-icon", size: 32)

            assert_equal %(<link rel="icon" type="image/x-icon" sizes="32x32" href="/assets/favicon.ico">), rendered_content
          end
        end
      end
    end
  end
end
