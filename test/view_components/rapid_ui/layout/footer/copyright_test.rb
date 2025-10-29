require_relative "../../view_component_test_case"

module RapidUI
  module Layout
    module Footer
      class CopyrightTest < ViewComponentTestCase
        described_class Copyright

        test "renders a basic copyright notice" do
          render_inline build(start_year: 2020, end_year: 2025, company_name: "Test Company")
          assert_equal %(<span>&copy; 2020-2025, Test Company</span>), rendered_content
        end

        test "escapes everything properly" do
          render_inline build(start_year: "20<20", end_year: "20>25", company_name: "<script>alert('test')</script>")
          assert_equal %(<span>&copy; 20&lt;20-20&gt;25, &lt;script&gt;alert(&#39;test&#39;)&lt;/script&gt;</span>), rendered_content
        end
      end
    end
  end
end
