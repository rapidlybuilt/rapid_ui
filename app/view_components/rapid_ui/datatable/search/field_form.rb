module RapidUI
  module Datatable
    module Search
      class FieldForm < ApplicationComponent
        # TODO: doesn't need to be dependent on table
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
            data: { turbo_stream: @table.turbo_stream },
          )

          url = self.url || table.table_path

          hidden_fields = @table.hidden_fields_for_registered_params(
            additional_params: { page: 1 },
            except: @table.search_param,
          )

          param = @table.search_param

          field = @table.search_field_tag(
            @table.param_name(param),
            @table.params[param],
            class: "datatable-search-input",
            autocomplete: "off",
            placeholder: t(".placeholder"),
          )

          helpers.form_tag(url, **attributes) do
            hidden_fields << field
          end
        end
      end
    end
  end
end
