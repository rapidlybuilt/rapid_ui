class Components::ControlsController < ApplicationController
  helper RapidUI::ControlsHelper

  before_action :set_breadcrumbs

  private

  def set_breadcrumbs
    layout.subheader.with_breadcrumb("Components")
    layout.subheader.with_breadcrumb("Controls")
  end
end
