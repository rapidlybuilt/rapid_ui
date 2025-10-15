class Components::ContentController < ApplicationController
  helper RapidUI::ContentHelper
  helper RapidUI::Controls::ButtonsHelper

  before_action :set_breadcrumbs

  private

  def set_breadcrumbs
    layout.subheader.breadcrumbs.build("Components")
    layout.subheader.breadcrumbs.build("Content")
  end
end
