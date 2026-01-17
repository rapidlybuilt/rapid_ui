module ApplicationHelper
  def render_feature_list(items)
    render "components/categories/list", items:
  end
end
