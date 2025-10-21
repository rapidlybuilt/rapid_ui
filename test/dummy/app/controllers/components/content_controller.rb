class Components::ContentController < Components::BaseController
  helper RapidUI::ContentHelper
  helper RapidUI::Controls::ButtonsHelper

  private

  def set_breadcrumbs
    super
    layout.subheader.build_breadcrumb("Content", components_content_path)
  end
end
