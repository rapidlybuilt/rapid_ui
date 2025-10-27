require_relative "../view_component_test_case"

module RapidUI
  module Forms
    class RadioButtonGroupTest < ViewComponentTestCase
      described_class RadioButtonGroup

      test "renders a basic vertical radio button group" do
        render_inline build("color", id: "color_field", colspans: { group: 12 }) do |g|
          g.with_option("red", true, "Red")
          g.with_option("blue", false, "Blue")
        end

        assert_selector "div.col-span-12"
        assert_selector "div.field-buttons" do
          assert_selector "label.field-label", count: 2
          assert_selector "input[type='radio'][name='color'][value='red'][checked]"
          assert_selector "input[type='radio'][name='color'][value='blue']"
          assert_selector "span.field-check-label", text: "Red"
          assert_selector "span.field-check-label", text: "Blue"
        end
      end

      test "renders horizontal radio button group" do
        render_inline build("size", id: "size_field", horizontal: true, colspans: { group: 12, label: 3, content: 9 }) do |g|
          g.with_label("Size")
          g.with_option("small", false, "Small")
          g.with_option("large", true, "Large")
        end

        assert_selector ".grid.grid-cols-12" do
          assert_selector "label.col-field-label", text: "Size"
          assert_selector "div.col-span-12.md\\:col-span-9" do
            assert_selector "label.field-label", count: 2
            assert_selector "input[type='radio'][name='size'][value='small']"
            assert_selector "input[type='radio'][name='size'][value='large'][checked]"
          end
        end
      end

      test "renders with disabled option" do
        render_inline build("choice", id: "choice_field", colspans: { group: 12 }) do |g|
          g.with_option("yes", false, "Yes")
          g.with_option("no", false, "No", disabled: true)
        end

        assert_selector "input[type='radio'][value='yes']:not([disabled])"
        assert_selector "input[type='radio'][value='no'][disabled]"
        assert_selector "label.field-label.disabled"
      end
    end
  end
end

