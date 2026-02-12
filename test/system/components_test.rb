require "test_helper"

class ComponentsTest < ActionDispatch::SystemTestCase
  class TestComponent < RapidUI::ApplicationComponent
    self.param_name = :foo

    def call
      tag.div("Component content")
    end

    def csv_stream
      RapidUI::CsvStream.new(filename: "component.csv") do |stream|
        stream.write("id,name\n1,Component content\n")
      end
    end

    def to_json
      { content: "Component content" }.to_json
    end
  end

  class UnsupportedCsvComponent < RapidUI::ApplicationComponent
    self.param_name = :foo
  end

  driven_by :rack_test

  setup do
    ComponentsController.test_component = TestComponent.new(id: "foo", factory: RapidUI::Factory.new)
  end

  teardown do
    ComponentsController.test_component = nil
  end

  test "renders the default action when not explicitly rendering the component" do
    visit "/component"
    assert_text "Main test content"
  end

  test "renders the component when its param is present" do
    visit "/component?component=foo"
    assert_text "Component content"
  end

  test "renders a 404 when asking for a component that doesn't exist" do
    visit "/component?component=bar"
    assert_equal 404, page.status_code
    assert_text "Component not found"
  end

  test "HTML render" do
    visit "/component.html?component=foo"
    assert_equal 200, page.status_code
    assert_equal "<div>Component content</div>", page.body
  end

  test "CSV render" do
    visit "/component.csv?component=foo"
    assert_equal 200, page.status_code
    assert_equal "id,name\n1,Component content\n", page.body
  end

  test "renders a 406 when the CSV component doesn't support CSV" do
    ComponentsController.test_component = UnsupportedCsvComponent.new(factory: RapidUI::Factory.new)
    visit "/component.csv?component=foo"
    assert_equal 406, page.status_code
    assert_text "CSV not supported for this component"
  end

  test "JSON render" do
    visit "/component.json?component=foo"
    assert_equal 200, page.status_code
    assert_equal({ content: "Component content" }.to_json, page.body)
  end

  test "Turbo Stream render" do
    visit "/component.turbo_stream?component=foo"
    assert_equal 200, page.status_code
    assert_equal %(<turbo-stream action="replace" target="foo"><template><div>Component content</div>\n</template></turbo-stream>), page.body
  end

  test "supports blank component names" do
    ComponentsController.test_component.param_name = nil

    # renders the default action w/o a component param
    visit "/component"
    assert_text "Main test content"

    # renders the component with a blank component param
    visit "/component.html?component="
    assert_text "Component content"
  end
end
