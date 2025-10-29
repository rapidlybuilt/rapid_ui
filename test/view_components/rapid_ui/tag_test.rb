require_relative "view_component_test_case"

module RapidUI
  class TagTest < ViewComponentTestCase
    described_class Tag

    test "renders plain text without tag wrapper when tag_name is nil" do
      render_inline build(tag_name: nil) do
        "Plain Text"
      end

      assert_text "Plain Text"
      refute_selector "div"
    end

    test "renders tag with div by default" do
      render_inline build(tag_name: :div) do
        "Div Content"
      end

      assert_selector "div", text: "Div Content"
    end

    test "renders tag with custom tag_name span" do
      render_inline build(tag_name: :span) do
        "Span Content"
      end

      assert_selector "span", text: "Span Content"
    end

    test "renders tag with custom CSS class" do
      render_inline build(tag_name: :div, class: "custom-class") do
        "Custom"
      end

      assert_selector "div.custom-class", text: "Custom"
    end

    test "renders tag with paragraph tag" do
      render_inline build(tag_name: :p) do
        "Paragraph Content"
      end

      assert_selector "p", text: "Paragraph Content"
    end

    test "renders tag with section tag" do
      render_inline build(tag_name: :section) do
        "Section Content"
      end

      assert_selector "section", text: "Section Content"
    end

    test "renders tag with data attributes" do
      render_inline build(tag_name: :div, data: { controller: "example" }) do
        "Data Attributes"
      end

      assert_selector "div[data-controller='example']", text: "Data Attributes"
    end
  end
end
