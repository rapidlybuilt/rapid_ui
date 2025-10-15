require "rouge"

class CodeBlock < ApplicationComponent
  attr_accessor :code
  attr_accessor :language

  def initialize(code, language: nil, **kwargs)
    super(**kwargs, additional_class: "code-theme-light")

    @code = code
    @language = language
  end

  def call
    component_tag(:pre, highlighted_code, **tag_attributes)
  end

  def highlighted_code
    return code unless language

    formatter = Rouge::Formatters::HTML.new

    lexer = {
      "erb" => Rouge::Lexers::ERB.new,
      "html" => Rouge::Lexers::HTML.new,
    }[language] || raise("Unknown language: #{language}")

    formatter.format(lexer.lex(code)).html_safe
  end

  class << self
    def build_from_block_source(block, language:, **kwargs)
      end_indicator = {
        "erb" => "<% end %>",
        "rb" => "end",
      }[language] || raise("Unknown language: #{language}")

      source_file, source_line = block.source_location
      source = File.read(source_file).split("\n")

      start_line = source_line
      end_line = nil

      indention = line_indention(source[start_line-1])
      end_source = (" " * indention) + end_indicator

      source[start_line..-1].each_with_index do |line, i|
        if line == end_source
          end_line = start_line + i
          break
        end
      end

      raise "Could not find source" unless end_line
      code = remove_indentation(source[start_line..end_line-1])

      new(code, language:, **kwargs)
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
end
