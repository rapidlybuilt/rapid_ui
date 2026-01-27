class SearchController < ApplicationController
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
