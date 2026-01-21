require_relative "../../view_component_test_case"

module RapidUI
  module Layout
    module Head
      class OpenGraphTest < ViewComponentTestCase
        described_class OpenGraph

        test "renders default locale" do
          render_inline build { |og|
            og.locale = "en_US"
          }

          assert_selector "meta[property='og:locale'][content='en_US']", visible: false
          assert_selector "meta[property='og:type'][content='article']", visible: false
        end

        test "renders Open Graph meta tags" do
          render_inline build { |og|
            og.title = "My Page Title"
            og.url = "https://example.com/page"
            og.description = "This is the page description"
            og.image_url = "https://example.com/image.png"
          }

          assert_selector "meta[property='og:title'][content='My Page Title']", visible: false
          assert_selector "meta[property='og:url'][content='https://example.com/page']", visible: false
          assert_selector "meta[property='og:description'][content='This is the page description']", visible: false
          assert_selector "meta[property='og:image'][content='https://example.com/image.png']", visible: false
        end

        test "renders Twitter card meta tags" do
          render_inline build { |og|
            og.title = "My Page Title"
            og.url = "https://example.com/page"
            og.description = "This is the page description"
            og.image_url = "https://example.com/image.png"
            og.domain = "example.com"
          }

          assert_selector "meta[name='twitter:title'][content='My Page Title']", visible: false
          assert_selector "meta[name='twitter:url'][content='https://example.com/page']", visible: false
          assert_selector "meta[name='twitter:description'][content='This is the page description']", visible: false
          assert_selector "meta[name='twitter:image'][content='https://example.com/image.png']", visible: false
          assert_selector "meta[name='twitter:card'][content='summary_large_image']", visible: false
          assert_selector "meta[name='twitter:domain'][content='example.com']", visible: false
        end

        test "truncates long descriptions" do
          long_description = "This is a very long description that exceeds one hundred characters and should be truncated with an ellipsis at the end"

          render_inline build { |og|
            og.description = long_description
          }

          # Description should be truncated to 100 chars with "..." at word boundary
          assert_selector "meta[property='og:description']", visible: false
          meta = page.find("meta[property='og:description']", visible: false)
          assert meta[:content].length <= 100
          assert meta[:content].end_with?("...")
        end

        test "normalizes whitespace in descriptions" do
          render_inline build { |og|
            og.description = "  Multiple   spaces   and\n\nnewlines  "
          }

          meta = page.find("meta[property='og:description']", visible: false)
          assert_equal "Multiple spaces and newlines", meta[:content]
        end

        test "allows custom locale" do
          render_inline build { |og|
            og.locale = "fr_FR"
          }

          assert_selector "meta[property='og:locale'][content='fr_FR']", visible: false
        end

        test "omits optional tags when not set" do
          render_inline build

          assert_no_selector "meta[property='og:title']", visible: false
          assert_no_selector "meta[property='og:url']", visible: false
          assert_no_selector "meta[property='og:description']", visible: false
          assert_no_selector "meta[property='og:image']", visible: false
          assert_no_selector "meta[name='twitter:title']", visible: false
          assert_no_selector "meta[name='twitter:domain']", visible: false
        end
      end
    end
  end
end
