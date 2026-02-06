# frozen_string_literal: true

# This concern is used to add rapid_table functionality to controllers.
module UsesRapidTables
  def determine_rapid_table_class(records)
    "#{records.klass.name.pluralize}Table".constantize
  end

  def rapid_table(records = nil, table_class: nil, title: nil, **options, &block)
    table_class ||= determine_rapid_table_class(records)
    table = ui.build(table_class, records, params:, **options, &block)

    # TODO: only build header when setting say so
    table.build_header do |header|
      # TODO: how to better space these components out?
      header.build_tag(title, tag_name: :div) if title

      if table.respond_to?(:skip_bulk_actions?) && !table.skip_bulk_actions?
        header.build_bulk_actions(table:, class: "datatable-bulk-actions-select-container")
      end

      unless table.class.select_filter_definitions.empty? && table.skip_search?
        header.build_filters(table:) do |filters|
          table.class.select_filter_definitions.each do |definition|
            filter_id = definition[:filter_id]
            options = definition[:options]
            filter = definition[:filter]

            filters.build_select_filter(filter_id, options:, filter:)
          end

          filters.build_search_field_form unless table.skip_search?
        end
      end
    end

    unless table.only_ever_one_page? && table.skip_export?
      table.build_footer do |footer|
        unless table.only_ever_one_page?
          footer.build_per_page(table:)
          footer.build_pagination(table:)
        end

        unless table.skip_export?
          footer.build_exports(table:)
        end
      end
    end

    table
  end

  def rapid_table?(table)
    params[:table] && (!table.param_name || params[:table] == table.param_name.to_s)
  end

  def redirect_to_rapid_table(table, notice: nil, alert: nil, **options)
    redirect_to table.table_path(view_context: self, **options), notice:, alert:
  end

  def rapid_table_csv(table, filename: nil)
    return unless rapid_table?(table)

    filename ||= "#{table.id}-#{Time.now.strftime("%Y-%m-%d")}.csv"

    response.headers["Content-Type"] = "text/csv"
    response.headers["Content-Disposition"] = %(attachment; filename="#{filename}")
    response.headers["Last-Modified"] = Time.current.httpdate

    # Use streaming response
    response.headers["X-Accel-Buffering"] = "no" if response.headers["X-Accel-Buffering"]

    # Stream the CSV data
    table.stream_csv(response.stream)

    # Close the stream
    response.stream.close
  end

  def rapid_table_json(table)
    return unless rapid_table?(table)

    render json: table.to_json
  end

  def replace_rapid_table_stream(table, partial: nil, locals: {})
    return unless rapid_table?(table)

    partial ||= table.class.name.underscore.sub("_table", "/table")

    turbo_stream.replace(
      table.id,
      partial:,
      locals: locals.merge(table:),
    )
  end

  def replace_rapid_table(table, partial: nil, locals: {})
    stream = replace_rapid_table_stream(table, partial:, locals:)
    render turbo_stream: stream if stream
  end
end
