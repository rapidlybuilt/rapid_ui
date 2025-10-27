class Components::FormsController < Components::BaseController
  helper RapidUI::FormsHelper
  helper RapidUI::Content::BadgesHelper

  private

  def set_breadcrumbs
    super
    build_breadcrumb("Forms", components_forms_path)
  end
end
