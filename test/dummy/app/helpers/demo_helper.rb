module DemoHelper
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
    html_code = CodeBlock.new(format_html(html), language: "html") unless skip_html

    erb_code = nil unless erb_code.include?("<%")

    render Demo.new(
      html: erb_html || helper_html,
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
    erb_normalized = normalize_html_for_comparison(erb_html)
    helper_normalized = normalize_html_for_comparison(helper_html)

    unless erb_normalized == helper_normalized
      # Find the first difference
      min_length = [ erb_normalized.length, helper_normalized.length ].min
      diff_index = (0...min_length).find { |i| erb_normalized[i] != helper_normalized[i] }

      # If no difference found in the common length, the difference is at the end
      diff_index ||= min_length

      # Show context around the difference
      context_start = [ 0, diff_index - 50 ].max
      context_end = [ erb_normalized.length, diff_index + 50 ].min

      erb_context = erb_normalized[context_start...context_end]
      helper_context = helper_normalized[context_start...context_end]

      # Mark the difference point
      erb_marked = erb_context.dup
      helper_marked = helper_context.dup
      relative_pos = diff_index - context_start

      # Only mark if the position is within the context
      if relative_pos >= 0 && relative_pos < erb_context.length
        erb_marked[relative_pos] = "❌#{erb_marked[relative_pos]}❌"
      end
      if relative_pos >= 0 && relative_pos < helper_context.length
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

  private

  def format_html(html)
    return html if html.blank?

    # Parse the HTML with Nokogiri
    doc = Nokogiri::HTML.fragment(html)

    # Format with proper indentation
    formatted = format_node(doc, 0)

    # Clean up extra newlines and return
    formatted.strip
  end

  def format_node(node, indent_level)
    indent = "  " * indent_level
    result = []
    children = node.children.to_a
    element_children = children.select { |c| c.type == Nokogiri::XML::Node::ELEMENT_NODE }

    children.each_with_index do |child, index|
      case child.type
      when Nokogiri::XML::Node::ELEMENT_NODE
        # Format opening tag
        tag_name = child.name
        attributes = format_attributes(child)
        is_multiline = false

        # Check if there are any element siblings after this one
        has_element_sibling_after = element_children.index(child) < element_children.length - 1

        if child.children.empty?
          # Self-closing or empty tag
          result << "#{indent}<#{tag_name}#{attributes}></#{tag_name}>"
        elsif tag_name == "svg"
          # Keep SVG tags inline without line breaks
          svg_html = child.to_html.gsub(/\s+/, " ").gsub(/>\s+</, "><").strip
          result << "#{indent}#{svg_html}"
        elsif child.children.size == 1 && child.children.first.text?
          # Single text node child - keep inline
          text_content = child.children.first.text.strip
          result << "#{indent}<#{tag_name}#{attributes}>#{text_content}</#{tag_name}>"
        else
          # Multiple children or non-text children - format with indentation
          is_multiline = true
          result << "#{indent}<#{tag_name}#{attributes}>"
          result << format_node(child, indent_level + 1)
          result << "#{indent}</#{tag_name}>"
        end

        # Add extra line break after multi-line elements (except for the last element child)
        result << "" if is_multiline && has_element_sibling_after
      when Nokogiri::XML::Node::TEXT_NODE
        text = child.text.strip
        result << "#{indent}#{text}" unless text.empty?
      when Nokogiri::XML::Node::COMMENT_NODE
        result << "#{indent}<!-- #{child.text.strip} -->"
      end
    end

    result.join("\n")
  end

  def format_attributes(node)
    return "" if node.attributes.empty?

    attrs = node.attributes.map do |name, attr|
      value = attr.value
      # Escape quotes in attribute values
      value = value.gsub('"', "&quot;") if value.include?('"') && !value.include?("&quot;")
      %Q(#{name}="#{value}")
    end.join(" ")

    " #{attrs}"
  end

  def normalize_html_for_comparison(html)
    # First, normalize all whitespace to single spaces
    normalized = html.gsub(/\s+/, " ")

    # Remove whitespace between HTML tags and content
    # This handles cases like: <button> Notifications</button> vs <button>Notifications</button>
    normalized = normalized.gsub(/>\s+([^<])/, '>\1')

    # Remove whitespace between HTML tags and content (including other HTML tags)
    # This handles cases like: <button> <p>content</p> vs <button><p>content</p>
    normalized = normalized.gsub(/>\s+</, "><")

    # Remove any remaining leading/trailing whitespace
    normalized.strip
  end
end
