class Components::Controls::DatatablesController < Components::BaseController
  include UsesRapidTables

  before_action :load_countries

  def index
    @full_example_table = rapid_table(@countries, table_class: CountriesTable, id: :full_example)
    @full_example_table.build_search_field_form unless @full_example_table.skip_search? # TODO: remove this

    respond_to do |format|
      format.html
      format.turbo_stream { replace_rapid_table(@full_example_table, partial: "table") }
      format.csv { rapid_table_csv(@full_example_table) }
      format.json { rapid_table_json(@full_example_table) }
    end
  end

  private

  def load_countries
    @countries = YAML.load_file(Rails.root.join("db", "countries.yml")).map do |country|
      Country.new(*country.values)
    end
  end

  Country = Struct.new(:name, :capital, :population, :region, :un_member, :openstreetmap)

  class CountriesTable < RapidUI::Datatable::Base
    include RapidTable::Adapters::Array

    columns do |t|
      t.string :name, sortable: true, searchable: true
      t.string :capital
      t.integer :population, sortable: true, sort_order: "desc"
      t.string :region
      t.boolean :un_member, label: "UN Member"
      t.string :openstreetmap, label: "OpenStreetMap"
    end

    self.sort_column = :name
    self.available_per_pages = [10, 25, 50, 100]
    self.per_page = 10

    column_html :openstreetmap do |record|
      link_to helpers.icon("globe", size: 16), record.openstreetmap, target: "_blank"
    end

    select_filter :region,
      options: ->(scope) { scope.map(&:region).uniq.sort },
      filter: ->(scope, value) { scope.keep_if { |record| record.region == value } }
  end
end
