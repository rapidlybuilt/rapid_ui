class SearchController < ApplicationController
  def show
    search_data = self.class.static_results

    @results = ui.build(RapidUI::Search::Results)

    query = params[:q]&.strip&.downcase
    query.present? && search_data.each do |item|
      next unless item[:title].downcase.include?(query) || item[:description].downcase.include?(query)

      @results.with_item(
        title: item[:title],
        url: item[:url],
        description: item[:description],
      )
    end

    # TODO: clean up this interface
    render inline: helpers.render(@results), layout: !request.xhr?
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
