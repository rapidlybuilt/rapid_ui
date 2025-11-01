class ThemesController < ApplicationController
  before_action :set_available_themes
  before_action :set_main_sidebar
  before_action :set_breadcrumbs

  def show
    @theme = ParseTheme.call(params[:id])
  end

  def night_owl2
    # raise "asdf"
    @theme = ParseTheme2.call("night_owl2")
  end

  private

  def set_available_themes
    @available_theme_ids = t("themes").keys
  end

  def set_main_sidebar
    with_navigation_sidebar do |sidebar|
      sidebar.title = "Themes"

      sidebar.build_navigation do |navigation|
        @available_theme_ids.each do |theme_id|
          navigation.build_link(t("themes.#{theme_id}.title"), theme_path(theme_id))
        end
      end
    end
  end

  def set_breadcrumbs
    build_breadcrumb("Themes", themes_path)
  end
end
