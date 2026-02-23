module RapidUI
  module Datatable
    module Adapters
      module Rails
        # The action in which the table appears by default (not in response to a POST action).
        attr_accessor :action_name

        # Generates a path for the component.
        #
        # @param view_context [ActionView::Base, nil] The view context to use
        # @param format [String, nil] The format to use
        # @param options [Hash] The options to use
        # @return [String] The generated path
        # @example
        #   component_path(page: 2)
        #   # => "/users?component=&sort=name&page=2"
        def component_path(view_context: nil, format: nil, **options)
          options = options.reverse_merge(persistent_params)
          if param_name
            (view_context || helpers).url_for(action: action_name, component: param_name, param_name => options, format:)
          else
            (view_context || helpers).url_for(action: action_name, format:, component: "", **options)
          end
        end
      end
    end
  end
end
