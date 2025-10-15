module DemoHelper
  def demo_section_header(title, id: title.parameterize)
    tag.h2(link_to(title, "##{id}"), id:, class: "typography-h2")
  end

  def demo_code(helper: nil, skip_flex: false, skip_html: false, skip_html_check: false, &erb_block)
    erb_html = capture(&erb_block) if erb_block
    helper_html = send(helper) if helper
    html = CodeBlock.remove_indentation(helper_html || erb_html)

    # ensure the helper and ERB are the same (minus whitespace)
    if erb_html && helper_html && !skip_html_check
      demo_check_html(helper, erb_html, helper_html)
    end

    erb_code = CodeBlock.build_from_block_source(erb_block, language: "erb") if erb_block
    ruby_code = CodeBlock.build_from_demo_helper(method(helper)) if helper
    html_code = CodeBlock.new(html, language: "html") unless skip_html

    erb_code = nil unless erb_code.include?("<%")

    render Demo.new(
      html: helper_html || erb_html,
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

  def demo_check_html(helper, erb_html, helper_html)
    erb_normalized = erb_html.squish
    helper_normalized = helper_html.squish

    unless erb_normalized == helper_normalized
      # Find the first difference
      min_length = [erb_normalized.length, helper_normalized.length].min
      diff_index = (0...min_length).find { |i| erb_normalized[i] != helper_normalized[i] }

      # Show context around the difference
      context_start = [0, diff_index - 50].max
      context_end = [erb_normalized.length, diff_index + 50].min

      erb_context = erb_normalized[context_start...context_end]
      helper_context = helper_normalized[context_start...context_end]

      # Mark the difference point
      if diff_index
        erb_marked = erb_context.dup
        helper_marked = helper_context.dup
        relative_pos = diff_index - context_start
        erb_marked[relative_pos] = "❌#{erb_marked[relative_pos]}❌"
        helper_marked[relative_pos] = "❌#{helper_marked[relative_pos]}❌"
      end

      error_message = <<~ERROR
        Helper HTML is not the same: #{helper}

        ERB HTML (normalized):
        #{erb_marked}

        Helper HTML (normalized):
        #{helper_marked}

        Full ERB HTML:\n#{erb_html}

        Full Helper HTML:\n#{helper_html}
      ERROR

      raise error_message
    end
  end
end
