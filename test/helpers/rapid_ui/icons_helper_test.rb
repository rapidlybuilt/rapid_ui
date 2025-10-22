require_relative "helper_test_case"

module RapidUI
  class IconsHelperTest < HelperTestCase
    include RapidUI::IconsHelper

    test "new_icon returns an Icon component" do
      icon = new_icon("check")
      assert_instance_of Icon, icon
    end

    test "new_icon accepts icon name" do
      icon = new_icon("check")
      assert_equal "check", icon.name
    end

    test "new_icon accepts size option" do
      icon = new_icon("check", size: 24)
      assert_equal 24, icon.size
    end

    test "new_icon accepts spin option" do
      icon = new_icon("loader", spin: true)
      assert icon.spin?
    end

    test "icon helper renders the icon" do
      render_inline icon("check")
      assert_selector "svg[width='16'][height='16']"
    end

    test "icon helper with custom size" do
      render_inline icon("check", size: 24)
      assert_selector "svg[width='24'][height='24']"
    end

    test "icon helper with spin option" do
      render_inline icon("loader", spin: true)
      assert_selector "svg.spin"
    end
  end
end
