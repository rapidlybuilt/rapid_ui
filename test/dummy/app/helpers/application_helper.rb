module ApplicationHelper
  def html_code(&block)
    tag.code String.new(capture(&block).strip)
  end
end
