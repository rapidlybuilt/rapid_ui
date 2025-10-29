require_relative "../../view_component_test_case"

module RapidUI
  module Layout
    module Footer
      class BaseTest < ViewComponentTestCase
        described_class Base

        test "renders an empty footer tag by default" do
          render_inline build
          assert_selector "footer:empty"
        end

        test "renders left and right items" do
          render_inline build do |footer|
            footer.with_left.with_tag("Left")
            footer.with_right.with_tag("Right")
          end

          assert_selector "footer .footer-left", text: "Left"
          assert_selector "footer .footer-right", text: "Right"
        end

        test "renders a copyright" do
          render_inline build do |footer|
            footer.with_left.with_copyright(start_year: 2020, end_year: 2025, company_name: "Test Company")
          end

          assert_selector "footer .footer-left", text: "© 2020-2025, Test Company"
        end

        test "renders a text link" do
          render_inline build do |footer|
            footer.with_left.with_text_link("Text Link", "#")
          end

          assert_selector "footer .footer-left a[href='#']", text: "Text Link"
        end

        test "renders an icon link" do
          render_inline build do |footer|
            footer.with_left.with_icon_link("user", "#")
          end

          assert_selector "footer .footer-left a[href='#'] svg"
        end
      end
    end
  end
end
