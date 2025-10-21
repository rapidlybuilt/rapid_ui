module RapidUI
  class PropertyTable < Table
    def dynamic_css_class
      merge_classes("table-property", super)
    end

    def build_property(name, *value, &block)
      raise ArgumentError, "value and block cannot both be given" if value.length > 1 && block_given?

      build_body unless body

      body.build_row do |row|
        row.build_cell(name, scope: "row")

        if block_given?
          row.build_cell.with_content(&block)
        else
          row.build_cell(*value)
        end
      end
    end

    alias_method :with_property, :build_property
  end
end
