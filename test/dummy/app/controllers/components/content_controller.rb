class Components::ContentController < ApplicationController
  helper RapidUI::ContentHelper
  helper RapidUI::Controls::ButtonsHelper

  before_action :set_breadcrumbs

  private

  def set_breadcrumbs
    layout.subheader.with_breadcrumb("Components")
    layout.subheader.with_breadcrumb("Content")
  end
end
