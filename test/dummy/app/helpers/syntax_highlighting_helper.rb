require "rouge"

module SyntaxHighlightingHelper
  def syntax_highlight(code, language)
    formatter = Rouge::Formatters::HTML.new

    lexer = {
      "erb" => Rouge::Lexers::ERB.new,
      "html" => Rouge::Lexers::HTML.new,
    }[language] || raise("Unknown language: #{language}")

    formatter.format(lexer.lex(code)).html_safe
  end
end
