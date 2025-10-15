class StimulusController < ApplicationController
  helper RapidUI::SharedHelper

  before_action :set_breadcrumbs

  private

  def set_breadcrumbs
    layout.subheader.breadcrumbs.build("StimulusJS")
  end
end
