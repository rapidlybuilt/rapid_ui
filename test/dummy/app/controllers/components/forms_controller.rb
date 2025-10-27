class Components::FormsController < Components::BaseController
  helper RapidUI::FormsHelper

  private

  def set_breadcrumbs
    super
    build_breadcrumb("Forms", components_forms_path)
  end
end
