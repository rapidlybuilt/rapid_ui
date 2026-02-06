class Components::Controls::DatatablesController < Components::BaseController
  include UsesRapidTables

  before_action :load_countries
  before_action :load_full_example_table

  def index
    respond_with_table(@countries_table)
  end

  def bulk_action
    # TODO: perform action
    respond_with_table(@full_example_table)
  end

  private

  def load_countries
    @countries = YAML.load_file(Rails.root.join("db", "countries.yml")).map do |country|
      Country.new(country["name"].underscore, *country.values)
    end
  end

  def load_full_example_table
    @full_example_table = rapid_table(@countries, table_class: CountriesTable, id: :full_example)
    @full_example_table.build_search_field_form unless @full_example_table.skip_search? # TODO: remove this
    @full_example_table.table_name = "countries"
  end

  # TODO: remove this
  def respond_with_table(table)
    respond_to do |format|
      format.html
      format.turbo_stream { replace_rapid_table(@full_example_table, partial: "table") }
      format.csv { rapid_table_csv(@full_example_table) }
      format.json { rapid_table_json(@full_example_table) }
    end
  end

  Country = Struct.new(:id, :name, :capital, :population, :region, :un_member, :openstreetmap)

  class CountriesTable < RapidUI::Datatable::Base
    include RapidTable::Adapters::Array
    include RapidTable::Ext::BulkActions

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

    bulk_action :delete

    column_html :openstreetmap do |record|
      link_to helpers.icon("globe", size: 16), record.openstreetmap, target: "_blank"
    end

    select_filter :region,
      options: ->(scope) { scope.map(&:region).uniq.sort },
      filter: ->(scope, value) { scope.keep_if { |record| record.region == value } }

    def dom_id(record)
      "country_#{record.id}"
    end

    def record_id(record)
      record.id
    end
  end
end
