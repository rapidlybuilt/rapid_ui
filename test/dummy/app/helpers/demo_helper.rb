module DemoHelper
  def demo_section_header(title, id: title.parameterize)
    tag.h2(link_to(title, "##{id}"), id:, class: "typography-h2")
  end

  def demo_code(skip_wrapper: false, **kwargs, &block)
    html = capture(&block)
    erb_code = CodeBlock.build_from_block_source(block, language: "erb", class: "my-8")

    unless skip_wrapper
      css = "demo-row"
      css += " #{kwargs[:class]}" if kwargs[:class]
      html = tag.div(html, **kwargs, class: css)
    end

    safe_join([
      html,
      render(erb_code),
    ], "\n")
  end
end
