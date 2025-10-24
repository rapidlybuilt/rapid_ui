class Components::ContentController < Components::BaseController
  helper RapidUI::ContentHelper
  helper RapidUI::Controls::ButtonsHelper

  private

  def set_breadcrumbs
    super
    build_breadcrumb("Content", components_content_path)
  end
end
