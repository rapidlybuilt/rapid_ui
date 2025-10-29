require_relative "view_component_test_case"

module RapidUI
  class IconTest < ViewComponentTestCase
    described_class Icon

    test "renders a basic icon" do
      render_inline build("check")

      assert_selector "svg[width='16'][height='16']"
    end

    test "renders icon with custom size" do
      render_inline build("check", size: 24)

      assert_selector "svg[width='24'][height='24']"
    end

    test "renders icon with spin option" do
      render_inline build("loader", spin: true)

      assert_selector "svg.spin"
    end

    test "renders icon with custom CSS class" do
      render_inline build("check", class: "custom-icon")

      assert_selector "svg.custom-icon"
    end

    test "renders image icon" do
      render_inline build("logo")

      assert_selector "img[width='16'][height='16']"
    end

    test "renders image icon with custom size" do
      render_inline build("logo", size: 48)

      assert_selector "img[width='48'][height='48']"
    end
  end
end
