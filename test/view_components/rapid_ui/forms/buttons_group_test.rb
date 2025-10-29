require_relative "../view_component_test_case"

module RapidUI
  module Forms
    class ButtonsGroupTest < ViewComponentTestCase
      described_class ButtonsGroup

      test "renders a basic vertical buttons group" do
        render_inline build(colspans: { group: 12 }) do |c|
          c.with_submit_button("Save")
          c.with_cancel_link("/")
        end

        assert_selector "div.field-buttons.col-span-12"
        assert_selector "button[type='submit'].btn.btn-primary", text: "Save"
        assert_selector "a.btn.btn-secondary[href='/']", text: "Cancel"
      end

      test "renders horizontal buttons group" do
        render_inline build(horizontal: true, colspans: { group: 12, label: 3, content: 9 }) do |c|
          c.with_submit_button("Update")
          c.with_cancel_link("/dashboard")
        end

        assert_selector "div.col-span-12.grid.grid-cols-12"
        assert_selector "div.col-span-12.md\\:col-span-3"  # Empty spacer
        assert_selector "div.field-buttons.col-span-12.md\\:col-span-9" do
          assert_selector "button[type='submit'].btn.btn-primary", text: "Update"
          assert_selector "a.btn.btn-secondary[href='/dashboard']", text: "Cancel"
        end
      end

      test "renders submit button with custom text" do
        render_inline build(colspans: { group: 12 }) do |c|
          c.with_submit_button("Register Now")
        end

        assert_selector "button[type='submit'].btn.btn-primary", text: "Register Now"
      end

      test "renders cancel link with default text" do
        render_inline build(colspans: { group: 12 }) do |c|
          c.with_cancel_link("/")
        end

        assert_selector "a.btn.btn-secondary[href='/']", text: "Cancel"
      end

      test "renders cancel link with custom text" do
        render_inline build(colspans: { group: 12 }) do |c|
          c.with_cancel_link("Go Back", "/previous")
        end

        assert_selector "a.btn.btn-secondary[href='/previous']", text: "Go Back"
      end

      test "renders multiple buttons" do
        render_inline build(colspans: { group: 12 }) do |c|
          c.with_submit_button("Save")
          c.with_button("Preview", variant: "secondary")
          c.with_cancel_link("/")
        end

        assert_selector ".field-buttons" do
          assert_selector "button", count: 2
          assert_selector "a", count: 1
          assert_selector "button[type='submit']", text: "Save"
          assert_selector "button", text: "Preview"
          assert_selector "a.btn.btn-secondary", text: "Cancel"
        end
      end

      test "renders with custom colspan" do
        render_inline build(colspans: { group: 6 }) do |c|
          c.with_submit_button("Save")
        end

        assert_selector "div.field-buttons.col-span-12.md\\:col-span-6"
      end

      test "renders with custom CSS class" do
        render_inline build(colspans: { group: 12 }, class: "custom-buttons") do |c|
          c.with_submit_button("Save")
        end

        assert_selector "div.field-buttons.col-span-12.custom-buttons"
      end

      test "renders submit button with custom variant" do
        render_inline build(colspans: { group: 12 }) do |c|
          c.with_submit_button("Delete", variant: "danger")
        end

        assert_selector "button[type='submit'].btn.btn-danger", text: "Delete"
      end

      test "renders buttons with disabled state" do
        render_inline build(colspans: { group: 12 }) do |c|
          c.with_submit_button("Save", disabled: true)
        end

        assert_selector "button[type='submit'][disabled]", text: "Save"
      end
    end
  end
end
