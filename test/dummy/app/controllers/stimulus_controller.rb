class StimulusController < ApplicationController
  helper RapidUI::SharedHelper

  before_action :set_breadcrumbs

  private

  def set_breadcrumbs
    layout.subheader.with_breadcrumb("StimulusJS")
  end
end
