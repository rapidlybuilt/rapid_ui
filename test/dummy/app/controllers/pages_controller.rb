class PagesController < ApplicationController
  def dashboard
  end

  def buttons
  end

  def icons
    @icons = Dir.glob(File.join(RapidUI::Engine.root, "vendor/lucide_icons", "*.svg")).map do |path|
      File.basename(path, ".svg")
    end.sort
  end

  def typography
    layout.head.title = "Typography"
  end
end
