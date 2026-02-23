module RapidUI
  module RendersComponents
    extend ActiveSupport::Concern

    included do
      include RendersComponents
    end

    private

    def renderable_components
      @renderable_components ||= {}
    end

    def add_renderable_component(component, param_name: component.param_name.to_s)
      renderable_components[param_name] = component
    end

    def rendering_component?(component)
      params[:component] && (!component.param_name || params[:component] == component.param_name.to_s)
    end

    def respond_with_component(component = nil, **attributes)
      return if component && !rendering_component?(component)

      if params[:component]
        component ||= renderable_components[params[:component]]

        unless component
          render status: :not_found, plain: "Component not found"
          return true
        end
      end

      return unless component

      # allow setting component attributes before the response
      attributes.each do |attribute, value|
        component.send(:"#{attribute}=", value) if component.respond_to?(:"#{attribute}=")
      end

      respond_to do |format|
        format.turbo_stream { replace_component(component) }
        format.csv { stream_component_csv(component) }
        format.json { render_component_json(component) }
        format.any { render_component_html(component, xhr_only: true) }
      end

      true
    rescue => e
      Rails.logger.error e.backtrace.join("\n")
      raise e
    end

    def render_component_html(component, xhr_only: false)
      # only render the component HTML if it's an XHR request
      # otherwise we're exposing the component HTML without a layout
      if xhr_only && !request.xhr?
        query = request.query_parameters.except(:component)
        redirect_to query.any? ? "#{request.path}?#{query.to_param}" : request.path
        return
      end

      render component, layout: false
    end

    def stream_component_csv(component, filename: nil)
      return unless rendering_component?(component)

      stream = component.csv_stream if component.respond_to?(:csv_stream)

      unless stream
        render status: :not_acceptable, plain: "CSV not supported for this component"
        return
      end

      response.headers["Content-Type"] = "text/csv"
      response.headers["Content-Disposition"] = %(attachment; filename="#{stream.filename}")
      response.headers["Last-Modified"] = stream.last_modified.httpdate

      # Use streaming response
      response.headers["X-Accel-Buffering"] = "no" if response.headers["X-Accel-Buffering"] && !stream.accel_buffering

      # Stream the CSV data
      stream.write(response.stream)

      # Close the stream
      response.stream.close
    end

    def render_component_json(component)
      return unless rendering_component?(component)

      render json: component.to_json
    end

    def replace_component(component, partial: component.partial_path, locals: {})
      stream = replace_component_stream(component, partial:, locals:)
      render turbo_stream: stream if stream
    end

    def replace_component_stream(component, partial: component.partial_path, locals: {})
      return unless rendering_component?(component)

      turbo_stream.replace(
        component.id,
        partial:,
        object: component,
        locals:,
      )
    end
  end
end
