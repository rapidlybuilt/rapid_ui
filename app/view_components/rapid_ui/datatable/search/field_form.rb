module RapidUI
  module Datatable
    module Search
      class FieldForm < ApplicationComponent
        # HACK: shouldn't be dependent on table, how to better split this off from rapid_table?
        attr_accessor :table

        attr_accessor :url
        attr_accessor :form_method

        def initialize(table:, url: nil, form_method: :get, **kwargs)
          super(**kwargs)

          @table = table
          @url = url
          @form_method = :get
        end

        def call
          attributes = merge_attributes(
            component_tag_attributes,
            method: form_method,
            data: merge_data(
              component_tag_attributes[:data],
              { turbo_stream: @table.turbo_stream },
            ),
          )

          url = self.url || table.table_path(view_context: self)

          helpers.form_tag(url, **attributes) do
            @table.hidden_fields_for_registered_params(additional_params: { page: 1 }, except: @table.search_param) <<
              @table.search_field_tag(class: "datatable-search-input", autocomplete: "off")
          end
        end
      end
    end
  end
end
