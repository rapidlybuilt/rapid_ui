class Components::CategoriesController < Components::BaseController
  def index
    layout.subheader.build_breadcrumb("Index")
  end

  def content
    layout.subheader.build_breadcrumb("Content")
  end

  def controls
    layout.subheader.build_breadcrumb("Controls")
  end

  def feedback
    layout.subheader.build_breadcrumb("Feedback")
  end

  def forms
    layout.subheader.build_breadcrumb("Forms")
  end

  def navigation
    layout.subheader.build_breadcrumb("Navigation")
  end

  def charts
    layout.subheader.build_breadcrumb("Charts")
  end

  private

  def set_breadcrumbs
    layout.subheader.build_breadcrumb("Components", components_root_path)
  end
end
