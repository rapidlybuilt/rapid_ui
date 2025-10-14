class Theme::ControlsController < ApplicationController
  helper RapidUI::ControlsHelper

  before_action :set_breadcrumbs

  private

  def set_breadcrumbs
    layout.subheader.breadcrumbs.build("Theme")
    layout.subheader.breadcrumbs.build("Controls")
  end
end
