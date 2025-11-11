require_relative "../../view_component_test_case"

module RapidUI
  module Layout
    module Sidebar
      class BaseTest < ViewComponentTestCase
        described_class Base

        test "renders a basic sidebar with id" do
          render_inline build(id: "test-sidebar")

          assert_selector "aside.sidebar.sidebar-left[data-controller='sidebar']"
        end

        test "renders sidebar with title" do
          render_inline build(id: "test-sidebar", title: "My Sidebar")

          assert_selector "aside.sidebar"
          assert_text "My Sidebar"
        end

        test "renders sidebar in left position by default" do
          render_inline build(id: "test-sidebar")

          assert_selector "aside.sidebar.sidebar-left"
        end

        test "renders sidebar in right position" do
          render_inline build(id: "test-sidebar", position: :right)

          assert_selector "aside.sidebar.sidebar-right"
        end

        test "renders open sidebar by default on desktop" do
          render_inline build(id: "test-sidebar")

          assert_selector "aside.sidebar.open-lg"
        end

        test "renders closed sidebar" do
          render_inline build(id: "test-sidebar", closed: true)

          assert_selector "aside.sidebar"
          refute_selector "aside.sidebar.open"
        end

        test "renders with custom CSS class" do
          render_inline build(id: "test-sidebar", class: "custom-sidebar")

          assert_selector "aside.sidebar.custom-sidebar"
        end

        test "renders with close button by default" do
          render_inline build(id: "test-sidebar")

          assert_selector "aside.sidebar button[data-action='click->sidebar#close']"
        end

        test "renders with custom close button" do
          render_inline build(id: "test-sidebar") do |sidebar|
            sidebar.with_close_button("test-sidebar", class: "custom-close")
          end

          assert_selector "aside.sidebar button.custom-close"
        end

        test "renders left sidebar with chevron-left icon" do
          render_inline build(id: "test-sidebar", position: :left)

          assert_selector "aside.sidebar button svg"
        end

        test "renders right sidebar with chevron-right icon" do
          render_inline build(id: "test-sidebar", position: :right)

          assert_selector "aside.sidebar button svg"
        end

        test "renders with navigation child" do
          render_inline build(id: "test-sidebar") do |sidebar|
            sidebar.with_navigation do |nav|
              nav.with_link("Home", "/")
            end
          end

          assert_selector "aside.sidebar nav.sidebar-nav"
          assert_selector "aside.sidebar nav a[href='/']", text: "Home"
        end

        test "renders with table of contents child" do
          render_inline build(id: "test-sidebar") do |sidebar|
            sidebar.with_table_of_contents do |toc|
              toc.with_link("Section 1", "#section-1")
            end
          end

          assert_selector "aside.sidebar ul.sidebar-toc-list"
        end

        test "renders with multiple children" do
          render_inline build(id: "test-sidebar") do |sidebar|
            sidebar.with_navigation do |nav|
              nav.with_link("Home", "/")
            end
            sidebar.with_table_of_contents do |toc|
              toc.with_link("Section 1", "#section-1")
            end
          end

          assert_selector "aside.sidebar nav.sidebar-nav"
          assert_selector "aside.sidebar ul.sidebar-toc-list"
        end

        test "renders with data attributes including sidebar id" do
          render_inline build(id: "my-sidebar")

          assert_selector "aside[data-controller='sidebar']"
          assert_selector "aside[data-sidebar-closed-cookie-value='my-sidebar_closed']"
        end

        test "raises error for invalid position" do
          assert_raises(ArgumentError) do
            build(id: "test-sidebar", position: :invalid)
          end
        end
      end
    end
  end
end
