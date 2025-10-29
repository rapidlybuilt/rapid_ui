require "test_helper"

class RapidUITest < ActiveSupport::TestCase
  test "it has a version number" do
    assert RapidUI::VERSION
  end

  test "#merge_classes" do
    assert_equal "foo", RapidUI.merge_classes("foo", nil)
    assert_equal "bar", RapidUI.merge_classes(nil, "bar")
    assert_equal "foo bar", RapidUI.merge_classes("foo", "bar")
    assert_equal "foo bar baz", RapidUI.merge_classes("foo", "bar", "baz")
    assert_nil RapidUI.merge_classes(nil, nil)
  end

  test "#merge_attributes" do
    assert_nil RapidUI.merge_attributes(nil, nil)
    assert_equal({}, RapidUI.merge_attributes({}, {}))

    assert_equal(
      { class: "foo bar" },
      RapidUI.merge_attributes({ class: "foo" }, { class: "bar" }),
    )
    assert_equal(
      { data: { controller: "foo bar" } },
      RapidUI.merge_attributes({ data: { controller: "foo" } }, { data: { controller: "bar" } }),
    )
    assert_equal(
      { class: "foo bar", data: { controller: "foo bar", action: "click->bar#baz click->baz#qux" } },
      RapidUI.merge_attributes(
        { class: "foo", data: { controller: "foo", action: "click->bar#baz" } },
        { class: "bar", data: { controller: "bar", action: "click->baz#qux" } },
      ),
    )
  end

  test "#merge_data_controller" do
    assert_equal "foo", RapidUI.merge_data_controller("foo", nil)
    assert_equal "bar", RapidUI.merge_data_controller(nil, "bar")
    assert_equal "foo bar", RapidUI.merge_data_controller("foo", "bar")
    assert_equal "foo bar baz", RapidUI.merge_data_controller("foo", "bar", "baz")
    assert_nil RapidUI.merge_data_controller(nil, nil)
  end

  test "#merge_data_action" do
    assert_equal "click->foo#bar", RapidUI.merge_data_action("click->foo#bar", nil)
    assert_equal "click->bar#baz", RapidUI.merge_data_action(nil, "click->bar#baz")
    assert_equal "click->foo#bar click->bar#baz", RapidUI.merge_data_action("click->foo#bar", "click->bar#baz")
    assert_equal "click->foo#bar click->bar#baz click->baz#qux", RapidUI.merge_data_action("click->foo#bar", "click->bar#baz", "click->baz#qux")
    assert_nil RapidUI.merge_data_action(nil, nil)
  end

  test "#merge_data" do
    assert_equal({ controller: "foo" }, RapidUI.merge_data({ controller: "foo" }, nil))
    assert_equal({ controller: "foo" }, RapidUI.merge_data(nil, { controller: "foo" }))

    assert_equal(
      { controller: "foo", action: "click->bar#baz" },
      RapidUI.merge_data({ controller: "foo" }, { action: "click->bar#baz" }),
    )

    assert_equal(
      { controller: "foo bar", action: "click->bar#baz click->baz#qux" },
      RapidUI.merge_data({ controller: "foo", action: "click->bar#baz" }, { controller: "bar", action: "click->baz#qux" }),
    )
    assert_equal({}, RapidUI.merge_data(nil, nil))
  end
end
