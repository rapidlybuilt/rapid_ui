class StimulusController < ApplicationController
  before_action :set_breadcrumbs

  private

  def set_breadcrumbs
    layout.subheader.with_breadcrumb("StimulusJS")
  end
end
