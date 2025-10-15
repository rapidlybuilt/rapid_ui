module DemoHelper
  def demo_section_header(title, id: title.parameterize)
    tag.h2(link_to(title, "##{id}"), id:, class: "typography-h2")
  end

  def demo_code(helper: nil, skip_flex: false, skip_html: false, &erb_block)
    erb_html = capture(&erb_block) if erb_block
    helper_html = send(helper) if helper
    html = CodeBlock.remove_indentation(erb_html || helper_html)

    # ensure the helper and ERB are the same (minus whitespace)
    if erb_html && helper_html
      raise "Helper HTML is not the same: #{helper}" unless erb_html.gsub(/\s+/, "") == helper_html.gsub(/\s+/, "")
    end

    erb_code = CodeBlock.build_from_block_source(erb_block, language: "erb") if erb_block
    ruby_code = CodeBlock.build_from_demo_helper(method(helper)) if helper
    html_code = CodeBlock.new(html, language: "html") unless skip_html

    render Demo.new(
      erb_html:,
      helper_html:,
      erb_code:,
      ruby_code:,
      html_code:,
      skip_flex:,
    )
  end

  def demo_components(&block)
    demo_components = RapidUI::Components.new
    block.call(demo_components)
    render demo_components
  end
end
