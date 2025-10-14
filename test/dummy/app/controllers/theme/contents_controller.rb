class Theme::ContentsController < ApplicationController
  helper RapidUI::ContentHelper

  before_action :set_breadcrumbs

  private

  def set_breadcrumbs
    layout.subheader.breadcrumbs.build("Theme")
    layout.subheader.breadcrumbs.build("Content")
  end
end
