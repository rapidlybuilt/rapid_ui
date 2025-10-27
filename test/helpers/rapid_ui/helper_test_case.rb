require "test_helper"

module RapidUI
  class HelperTestCase < ActionView::TestCase
    include Capybara::Minitest::Assertions

    def factory
      @factory ||= Factory.new
    end

    def layout_component_class
      nil # no layout by default
    end

    # This provides a minimal implementation for testing helpers
    def ui
      @ui ||= RapidUI::UsesLayout::UI.new(factory, layout_component_class)
    end

    # Provide a page object for Capybara assertions
    # This allows us to use assert_selector and other Capybara matchers
    def page
      raise "rendered_content is nil. Call #render_inline first" if rendered_content.nil?
      Capybara.string(rendered_content)
    end

    attr_writer :rendered_content

    private

    def render_inline(html)
      @rendered_content = html
    end

    def rendered_content
      @rendered_content
    end
  end
end
