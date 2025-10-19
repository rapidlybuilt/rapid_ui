class Components::ContentController < ApplicationController
  helper RapidUI::ContentHelper
  helper RapidUI::Controls::ButtonsHelper

  before_action :set_breadcrumbs

  def icons
    @icons = [ "logo" ] + Dir.glob(File.join(RapidUI::Engine.root, "vendor/lucide_icons", "*.svg")).map do |path|
      File.basename(path, ".svg")
    end.sort
  end

  private

  def set_breadcrumbs
    layout.subheader.with_breadcrumb("Components")
    layout.subheader.with_breadcrumb("Content")
  end
end
