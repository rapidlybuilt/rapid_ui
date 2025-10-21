class Components::ControlsController < Components::BaseController
  helper RapidUI::ControlsHelper

  private

  def set_breadcrumbs
    super
    layout.subheader.build_breadcrumb("Controls", components_controls_path)
  end
end
