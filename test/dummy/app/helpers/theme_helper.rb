module ThemeHelper
  def html_code(&block)
    code = String.new(capture(&block).strip)
    tag.pre(tag.code(code))
  end

  def demo_code(tight: false, skip_wrapper: false, skip_ruby: false, skip_html: false, **kwargs, &block)
    html = capture(&block)
    raw_html = remove_indentation(html)
    ruby = retrieve_block_source(block)

    css = "demo-row"
    css += "-tight" if tight
    css += " #{kwargs[:class]}" if kwargs[:class]

    code = []

    unless skip_ruby
      code += [
        "<%# Ruby/ERB %>",
        ruby
      ]
    end

    unless skip_html
      code << "" unless code.empty?
      code += [
        "<!-- HTML -->",
        raw_html
      ]
    end

    # TODO: user select to see HTML or Ruby code
    safe_join([
      skip_wrapper ? html : tag.div(html, **kwargs, class: css),
      tag.div(tag.pre(tag.code(code.join("\n"))), class: "demo-code-block mt-4")
    ], "\n")
  end

  def retrieve_block_source(block)
    source_file, source_line = block.source_location
    source = File.read(source_file).split("\n")

    start_line = source_line
    end_line = nil

    indention = line_indention(source[start_line-1])
    end_source = (" " * indention) + "<% end %>"

    source[start_line..-1].each_with_index do |line, i|
      if line == end_source
        end_line = start_line + i
        break
      end
    end

    raise "Could not find source" unless end_line
    remove_indentation(source[start_line..end_line-1])
  end

  def line_indention(line)
    line.match(/^\s*/)[0].length
  end

  def remove_indentation(lines)
    lines = lines.split("\n") unless lines.is_a?(Array)

    first_line = lines[0]
    first_line = lines[1] if first_line == "" && lines[1]

    size = line_indention(first_line)
    lines.map { |line| line[size..-1] }.join("\n").strip
  end
end
