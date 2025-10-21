class Components::FormsController < Components::BaseController
  helper RapidUI::FormHelper

  private

  def set_breadcrumbs
    super
    layout.subheader.build_breadcrumb("Forms", components_forms_path)
  end
end
