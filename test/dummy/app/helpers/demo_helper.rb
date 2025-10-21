module DemoHelper
  def demo_code(helper: nil, skip_flex: false, skip_html_check: false, &erb_block)
    erb_html = capture(&erb_block) if erb_block
    helper_html = send(helper) if helper
    html = CodeBlock.remove_indentation(helper_html || erb_html)

    # ensure the helper and ERB are the same (minus whitespace)
    if erb_html && helper_html && !skip_html_check
      demo_check_html(helper, erb_html, helper_html)
    end

    erb_code = CodeBlock.build_from_block_source(erb_block, language: "erb", factory: rapid_ui) if erb_block
    ruby_code = CodeBlock.build_from_demo_helper(method(helper), factory: rapid_ui) if helper
    html_code = CodeBlock.new(demo_format_html(html), language: "html", factory: rapid_ui)

    erb_code = nil unless erb_code.include?("<%")

    render rapid_ui.build(
      Demo,
      html: erb_html || helper_html,
      erb_code:,
      ruby_code:,
      html_code:,
      skip_flex:,
    )
  end

  def demo_components(&block)
    demo_components = rapid_ui.build(RapidUI::Components)
    block.call(demo_components)
    render demo_components
  end

  def demo_check_html(helper, erb_html, helper_html)
    service = Demo::CompareHtml.new(helper, erb_html, helper_html)
    service.call
    raise service.error_message unless service.success?
  end

  def demo_format_html(html)
    Demo::FormatHtml.call(html)
  end
end
