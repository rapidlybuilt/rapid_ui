module DemoHelper
  def demo_section_header(title, id: title.parameterize)
    tag.h2(link_to(title, "##{id}"), id:, class: "typography-h2")
  end

  def demo_code(skip_flex: false, &block)
    html = capture(&block)
    erb_code = CodeBlock.build_from_block_source(block, language: "erb")

    # Create connected layout with border
    content_div = tag.div(html, class: "demo-content#{" demo-flex" unless skip_flex}")
    code_div = tag.div(render(erb_code), class: "demo-code")
    tag.div(content_div + code_div, class: "demo")
  end
end
