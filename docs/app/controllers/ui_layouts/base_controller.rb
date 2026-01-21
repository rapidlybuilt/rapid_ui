class UiLayouts::BaseController < ApplicationController
  before_action :set_layouts_breadcrumbs

  private

  def set_layouts_breadcrumbs
    build_breadcrumb("Layouts", layouts_root_path)
  end
end
