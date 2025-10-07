class PagesController < ApplicationController
  def layout
    render layout: "rapid_ui/application"
  end
end
