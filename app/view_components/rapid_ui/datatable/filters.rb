module RapidUI
  module Datatable
    class Filters < ApplicationComponent
      attr_accessor :table

      renders_many_polymorphic(:items,
        select_filter: ->(filter_id, options:, filter:) {
          build(SelectFilter, filter_id:, options:, filter:, table:)
        },
        search_field_form: ->(**kwargs) {
          build(SearchFieldForm, table:, **kwargs)
        },
        button: ->(*args, **kwargs) {
          build(Button, *args, **kwargs)
        }
      )

      def initialize(table:, **kwargs)
        super(**kwargs, class: merge_classes("datatable-filters", kwargs[:class]))

        @table = table
      end

      def call
        component_tag { safe_join(items) } unless items.empty?
      end
    end
  end
end
