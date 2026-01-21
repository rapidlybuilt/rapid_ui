require_relative "../../view_component_test_case"

module RapidUI
  module Layout
    module Head
      class OpenGraphTest < ViewComponentTestCase
        described_class OpenGraph

        test "renders with default type of website" do
          render_inline build

          assert_selector "meta[property='og:type'][content='website']", visible: false
        end

        test "renders custom type" do
          render_inline build { |og|
            og.type = "article"
          }

          assert_selector "meta[property='og:type'][content='article']", visible: false
        end

        test "renders Open Graph meta tags" do
          render_inline build { |og|
            og.locale = "en_US"
            og.type = "article"
            og.site_name = "My Site"
            og.title = "My Page Title"
            og.url = "https://example.com/page"
            og.description = "This is the page description"
            og.image_url = "https://example.com/image.png"
            og.image_alt = "A descriptive image"
          }

          assert_selector "meta[property='og:locale'][content='en_US']", visible: false
          assert_selector "meta[property='og:type'][content='article']", visible: false
          assert_selector "meta[property='og:site_name'][content='My Site']", visible: false
          assert_selector "meta[property='og:title'][content='My Page Title']", visible: false
          assert_selector "meta[property='og:url'][content='https://example.com/page']", visible: false
          assert_selector "meta[property='og:description'][content='This is the page description']", visible: false
          assert_selector "meta[property='og:image'][content='https://example.com/image.png']", visible: false
          assert_selector "meta[property='og:image:alt'][content='A descriptive image']", visible: false
        end

        test "renders twitter:card as summary_large_image when image present" do
          render_inline build { |og|
            og.image_url = "https://example.com/image.png"
            og.domain = "example.com"
          }

          assert_selector "meta[name='twitter:card'][content='summary_large_image']", visible: false
          assert_selector "meta[name='twitter:domain'][content='example.com']", visible: false
        end

        test "renders twitter:card as summary when no image" do
          render_inline build

          assert_selector "meta[name='twitter:card'][content='summary']", visible: false
        end

        test "truncates long descriptions to 160 characters" do
          long_description = "This is a very long description that exceeds one hundred sixty characters and should be truncated with an ellipsis at the end of the text to ensure it fits properly"

          render_inline build { |og|
            og.description = long_description
          }

          meta = page.find("meta[property='og:description']", visible: false)
          assert meta[:content].length <= 160
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

          assert_no_selector "meta[property='og:locale']", visible: false
          assert_no_selector "meta[property='og:site_name']", visible: false
          assert_no_selector "meta[property='og:title']", visible: false
          assert_no_selector "meta[property='og:url']", visible: false
          assert_no_selector "meta[property='og:description']", visible: false
          assert_no_selector "meta[property='og:image']", visible: false
          assert_no_selector "meta[property='og:image:alt']", visible: false
          assert_no_selector "meta[name='twitter:domain']", visible: false
        end
      end
    end
  end
end
