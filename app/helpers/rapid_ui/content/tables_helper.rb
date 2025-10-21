module RapidUI
  module Content
    module TablesHelper
      def table(*args, **kwargs, &block)
        render new_table(*args, **kwargs), &block
      end

      def new_table(*args, **kwargs, &block)
        rapid_ui.build Table, *args, **kwargs, &block
      end
    end
  end
end
