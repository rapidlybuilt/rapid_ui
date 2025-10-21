module RapidUI
  module Content
    module TablesHelper
      def table(*args, **kwargs, &block)
        render new_table(*args, **kwargs), &block
      end

      def new_table(*args, **kwargs, &block)
        rapid_ui.build Table, *args, **kwargs, &block
      end

      def new_table_caption(*args, **kwargs, &block)
        rapid_ui.build Table::Caption, *args, **kwargs, &block
      end

      def new_table_head(*args, **kwargs, &block)
        rapid_ui.build Table::Head, *args, **kwargs, &block
      end

      def new_table_body(*args, **kwargs, &block)
        rapid_ui.build Table::Body, *args, **kwargs, &block
      end

      def new_table_foot(*args, **kwargs, &block)
        rapid_ui.build Table::Foot, *args, **kwargs, &block
      end

      def new_table_row(*args, **kwargs, &block)
        rapid_ui.build Table::Row, *args, **kwargs, &block
      end

      def new_table_cell(*args, **kwargs, &block)
        rapid_ui.build Table::Cell, *args, **kwargs, &block
      end

      def new_table_header_cell(*args, **kwargs, &block)
        rapid_ui.build Table::Cell, *args, **kwargs, header: true, &block
      end
    end
  end
end

