require_relative "../../view_component_test_case"

module RapidUI
  module Layout
    module Head
      class BaseTest < ViewComponentTestCase
        described_class Base

        test "favicons" do
          mock = Minitest::Mock.new
          mock.expect(:call, "/assets/favicon.ico", [ "favicon.ico" ])
          mock.expect(:call, "/assets/apple-touch-icon.png", [ "apple-touch-icon.png" ])

          vc_test_view_context.stub(:image_path, mock) do
            render_inline build do |head|
              head.with_favicon("favicon.ico", type: "image/x-icon", size: 32)
              head.with_apple_touch_icon("apple-touch-icon.png")
            end

            assert_equal 1, page.find_css("link[rel='icon'][type='image/x-icon'][sizes='32x32'][href='/assets/favicon.ico']").length
            assert_equal 1, page.find_css("link[rel='apple-touch-icon'][href='/assets/apple-touch-icon.png']").length
          end
        end

        test "full title" do
          render_inline build do |head|
            head.title = "My Title"
            head.site_name = "My Site"
          end

          assert_equal "My Title - My Site", page.title
        end
      end
    end
  end
end
