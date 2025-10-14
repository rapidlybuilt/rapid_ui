module RapidUI
  module Layout
    module Footer
      class Copyright < ApplicationComponent
        attr_accessor :start_year
        attr_accessor :end_year
        attr_accessor :company_name

        def initialize(start_year:, end_year: Date.today.year, company_name:, **kwargs)
          super(**kwargs)

          raise ArgumentError, "start_year must be a number" unless start_year.is_a?(Integer)
          raise ArgumentError, "end_year must be a number" unless end_year.is_a?(Integer)

          @start_year = start_year
          @end_year = end_year
          @company_name = company_name
        end

        def year_range
          start_year == end_year ? start_year.to_s : "#{start_year}-#{end_year}"
        end

        def text
          "&copy; #{year_range}, #{h company_name}".html_safe
        end

        def call
          component_tag(:span, text)
        end
      end
    end
  end
end
