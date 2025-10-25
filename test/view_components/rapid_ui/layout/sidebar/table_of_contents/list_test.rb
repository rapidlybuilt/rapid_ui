require_relative "../../../view_component_test_case"

module RapidUI
  module Layout
    module Sidebar
      module TableOfContents
        class ListTest < ViewComponentTestCase
          described_class List

          test "renders a basic table of contents list" do
            render_inline(build)

            assert_selector "ul.sidebar-toc-list.sidebar-toc-list-depth-0"
          end

          test "renders with depth 0 by default" do
            render_inline(build)

            assert_selector "ul.sidebar-toc-list-depth-0"
          end

          test "renders with link items" do
            render_inline(build) do |list|
              list.with_link("Section 1", "#section-1")
              list.with_link("Section 2", "#section-2")
            end

            assert_selector "ul.sidebar-toc-list a[href='#section-1']", text: "Section 1"
            assert_selector "ul.sidebar-toc-list a[href='#section-2']", text: "Section 2"
          end

          test "renders with nested list" do
            render_inline(build) do |list|
              list.with_link("Section 1", "#section-1")
              list.with_list do |nested|
                nested.with_link("Subsection 1.1", "#subsection-1-1")
              end
            end

            assert_selector "ul.sidebar-toc-list-depth-0"
            assert_selector "ul.sidebar-toc-list-depth-0 ul.sidebar-toc-list-depth-1"
            assert_selector "ul.sidebar-toc-list-depth-1 a[href='#subsection-1-1']", text: "Subsection 1.1"
          end

          test "renders with multiple levels of nesting" do
            # TODO: determine why with_ methods don't work here
            render_inline(build) do |list|
              list.build_link("Section 1", "#section-1")
              list.build_list do |nested1|
                nested1.build_link("Subsection 1.1", "#subsection-1-1")
                nested1.build_list do |nested2|
                  nested2.build_link("Subsubsection 1.1.1", "#subsubsection-1-1-1")
                end
              end
            end

            assert_selector "ul.sidebar-toc-list-depth-0"
            assert_selector "ul.sidebar-toc-list-depth-1"
            assert_selector "ul.sidebar-toc-list-depth-2"
            assert_selector "ul.sidebar-toc-list-depth-2 a[href='#subsubsection-1-1-1']", text: "Subsubsection 1.1.1"
          end

          test "renders with custom CSS class" do
            render_inline(build(class: "custom-toc"))

            assert_selector "ul.sidebar-toc-list.custom-toc"
          end

          test "renders empty list" do
            render_inline(build)

            assert_selector "ul.sidebar-toc-list"
          end

          test "renders links with custom CSS classes" do
            render_inline(build) do |list|
              list.with_link("Section 1", "#section-1", class: "custom-link")
            end

            assert_selector "ul.sidebar-toc-list a.sidebar-link.custom-link[href='#section-1']", text: "Section 1"
          end

          test "renders complex nested structure" do
            render_inline(build) do |list|
              list.with_link("Chapter 1", "#chapter-1")
              list.with_list do |l1|
                l1.with_link("Section 1.1", "#section-1-1")
                l1.with_link("Section 1.2", "#section-1-2")
              end
              list.with_link("Chapter 2", "#chapter-2")
              list.with_list do |l1|
                l1.with_link("Section 2.1", "#section-2-1")
              end
            end

            assert_selector "ul.sidebar-toc-list-depth-0 > li > a[href='#chapter-1']", text: "Chapter 1"
            assert_selector "ul.sidebar-toc-list-depth-0 > li > a[href='#chapter-2']", text: "Chapter 2"

            assert_selector "ul.sidebar-toc-list-depth-1 > li > a[href='#section-1-1']", text: "Section 1.1"
            assert_selector "ul.sidebar-toc-list-depth-1 > li > a[href='#section-1-2']", text: "Section 1.2"
            assert_selector "ul.sidebar-toc-list-depth-1 > li > a[href='#section-2-1']", text: "Section 2.1"
          end
        end
      end
    end
  end
end
