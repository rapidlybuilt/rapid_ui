class SearchController < ApplicationController
  before_action :render_search_page, only: :show

  def show
    search_data = self.class.static_results

    query = params[:q]&.strip&.downcase
    results = []

    if query.present?
      search_data.each do |item|
        next unless item[:title].downcase.include?(query) || item[:description].downcase.include?(query)

        results << {
          title: item[:title],
          url: item[:url],
          description: item[:description],
        }
      end
    end

    render json: results
  end

  private

  def render_search_page
    return if request.xhr?

    ui.layout.subheader.css_class = "hidden"
    ui.layout.sidebars.first.css_class = "hidden" if ui.layout.sidebars.first.present?

    page = ui.build(RapidUI::Search::Page)
    page.dynamic_path = url_for(action: :show, format: :json)

    render page
  end

  class << self
    def static_results(root_path: "")
      data = YAML.load_file(Rails.root.join("config", "static_search.yml"))
      data.map do |item|
        {
          title: item["title"],
          url: File.join(root_path, item["path"]),
          description: item["description"],
        }
      end
    end
  end
end
