require_relative "view_component_test_case"

module RapidUI
  class LinkTest < ViewComponentTestCase
    described_class Link

    test "renders a basic link" do
      render_inline(build("Home", "/"))

      assert_selector "a[href='/']", text: "Home"
    end

    test "renders link with full path" do
      render_inline(build("About", "/about"))

      assert_selector "a[href='/about']", text: "About"
    end

    test "renders link with custom CSS class" do
      render_inline(build("Contact", "/contact", class: "custom-link"))

      assert_selector "a.custom-link[href='/contact']", text: "Contact"
    end

    test "renders link with data attributes" do
      render_inline(build("Settings", "/settings", data: { turbo_method: "post" }))

      assert_selector "a[href='/settings'][data-turbo-method='post']", text: "Settings"
    end

    test "renders link with external URL" do
      render_inline(build("External", "https://example.com"))

      assert_selector "a[href='https://example.com']", text: "External"
    end

    test "renders link with ID" do
      render_inline(build("Dashboard", "/dashboard", id: "main-dashboard"))

      assert_selector "a#main-dashboard[href='/dashboard']", text: "Dashboard"
    end
  end
end
