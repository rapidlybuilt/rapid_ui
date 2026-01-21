module RapidUI
  module HasGridColumns
    def grid_column_class(colspan, default: 12)
      return unless colspan

      if colspan.is_a?(Hash)
        colspan.map { |breakpoint, size| "#{breakpoint}:col-span-#{size}" }.join(" ") + " col-span-#{default}"
      elsif colspan.is_a?(String)
        "col-span-#{default} #{colspan}"
      elsif colspan == default
        "col-span-#{default}"
      else
        "col-span-#{default} md:col-span-#{colspan}"
      end
    end
  end
end
