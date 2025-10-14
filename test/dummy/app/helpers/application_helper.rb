module ApplicationHelper
  def html_code(&block)
    code = String.new(capture(&block).strip)
    tag.pre(tag.code(code))
  end
end
