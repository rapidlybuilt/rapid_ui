class PagesController < ApplicationController
  def dashboard
  end

  def buttons
  end

  def expandable
    layout.head.title = [ "Expandable", "Content" ]
  end

  def icons
    @icons = [ "logo" ] + Dir.glob(File.join(RapidUI::Engine.root, "vendor/lucide_icons", "*.svg")).map do |path|
      File.basename(path, ".svg")
    end.sort
  end

  def typography
    layout.head.title = "Typography"
  end
end
