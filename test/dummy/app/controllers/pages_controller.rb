class PagesController < ApplicationController
  def index
    layout.sidebars.first.tap do |sidebar|
      sidebar.title = "Home"

      sidebar.build_navigation do |navigation|
        navigation.build_link("Index", root_path)
        navigation.build_link("Components", components_root_path)
        navigation.build_link("StimulusJS", stimulus_path)
      end
    end
  end
end
