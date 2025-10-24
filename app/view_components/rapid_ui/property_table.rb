module RapidUI
  class PropertyTable < Table
    def dynamic_css_class
      merge_classes("table-property", super)
    end

    def with_property(name, *value, &block)
      raise ArgumentError, "value and block cannot both be given" if value.length > 1 && block_given?

      with_body unless body

      body.with_row do |row|
        row.with_cell(name, tag_name: :th, scope: "row")
        row.with_cell(*value, &block)
      end
    end
    alias_method :build_property, :with_property
  end
end
