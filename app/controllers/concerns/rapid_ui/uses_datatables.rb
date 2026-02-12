module RapidUI
  module UsesDatatables
    extend ActiveSupport::Concern

    # TODO: figure out a way around all the respond_to?

    included do
      include RendersComponents
    end

    private

    def build_datatable(table_class, *args, **kwargs, &)
      table = ui.build(table_class, *args, **kwargs, params:)

      build_datatable_header(table)
      build_datatable_footer(table)

      yield table if block_given?

      add_renderable_component(table)
      table
    end

    def build_datatable_header(table)
      skip_bulk_actions = !table.respond_to?(:skip_bulk_actions?) || table.skip_bulk_actions?
      skip_select_filters = !table.respond_to?(:skip_select_filters?) || table.skip_select_filters?
      skip_search = !table.respond_to?(:skip_search?) || table.skip_search?

      return if skip_bulk_actions && skip_select_filters && skip_search

      table.build_header do |header|
        unless skip_bulk_actions
          header.build_bulk_actions(table:, class: "datatable-bulk-actions-select-container")
        end

        unless skip_search && skip_select_filters
          header.build_group(table:, class: "datatable-filters") do |group|
            group.build_select_filters unless skip_select_filters
            group.build_search_field_form unless skip_search
          end
        end
      end
    end

    def build_datatable_footer(table)
      skip_export = !table.respond_to?(:skip_export?) || table.skip_export?
      skip_pagination = !table.respond_to?(:skip_pagination?) || table.skip_pagination?

      return if skip_pagination && skip_export

      # HACK: ensure exports are aligned to the right when there's no pagination
      justify_end = "justify-end" if skip_pagination && !skip_export

      table.build_footer class: justify_end do |footer|
        unless skip_pagination
          footer.build_per_page(table:)
          footer.build_pagination(class: "datatable-paginate")
        end

        unless skip_export
          footer.build_exports
        end
      end
    end
  end
end
