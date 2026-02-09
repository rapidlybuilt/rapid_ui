require_relative "../../view_component_test_case"

module RapidUI
  module Datatable
    module Pagination
      class LinksTest < ViewComponentTestCase
        described_class Links

        def setup
          @path = ->(page) { "/?page=#{page}" }
        end

        test "pagination_links renders with explicit current_page and total_pages" do
          render_inline(build(
            3,
            5,
            path: @path,
          ))

          assert_selector "nav.pagination[role='navigation'][aria-label='pager']" do
            assert_selector "span.first" do
              assert_selector "a[href='/?page=1']"
            end
            assert_selector "span.prev" do
              assert_selector "a[href='/?page=2'][rel='prev']"
            end
            assert_selector "span.page.current", text: "3"
            assert_selector "span.next" do
              assert_selector "a[href='/?page=4'][rel='next']"
            end
            assert_selector "span.last" do
              assert_selector "a[href='/?page=5']"
            end
          end
        end

        test "pagination_links with default siblings_count shows page range and gap" do
          render_inline(build(
            5,
            15,
            path: @path,
          ))

          assert_selector "nav.pagination" do
            # Default siblings_count is 4: show pages 1..9 (5-4 to 5+4), then gap
            assert_selector "span.page.current", text: "5"
            assert_selector "span.page a[href='/?page=1']"
            assert_selector "span.page a[href='/?page=9']"
            assert_selector "span.page.gap"
          end
        end

        test "pagination_links with siblings_count 0 shows only current page" do
          render_inline(build(
            3,
            5,
            path: @path,
            siblings_count: 0,
          ))

          assert_selector "nav.pagination" do
            assert_selector "span.page.current", text: "3", count: 1
            assert_no_selector "span.page.gap"
            assert_no_selector "span.page a"
          end
        end

        test "end limit of siblings" do
          render_inline(build(
            14,
            15,
            path: @path,
            siblings_count: 4,
          ))

          assert_selector "nav.pagination" do
            assert_selector "span.page.current", text: "14"
            assert_selector "span.page a[href='/?page=15']"
            assert_no_selector "span.page a[href='/?page=16']"
          end
        end
      end
    end
  end
end
