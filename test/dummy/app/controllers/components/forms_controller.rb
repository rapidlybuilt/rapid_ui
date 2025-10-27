class Components::FormsController < Components::BaseController
  helper RapidUI::FieldsHelper

  private

  def set_breadcrumbs
    super
    build_breadcrumb("Forms", components_forms_path)
  end
end
