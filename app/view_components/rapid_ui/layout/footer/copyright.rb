module RapidUI
  module Layout
    module Footer
      class Copyright < ApplicationComponent
        attr_accessor :start_year
        attr_accessor :end_year
        attr_accessor :company_name

        def initialize(start_year: Date.today.year, end_year: Date.today.year, company_name: nil, **kwargs)
          super(tag_name: :span, **kwargs)

          @start_year = start_year
          @end_year = end_year
          @company_name = company_name

          yield self if block_given?
        end

        def year_range
          start_year == end_year ? h(end_year) : "#{h start_year}-#{h end_year}".html_safe
        end

        def call
          component_tag("&copy; #{year_range}, #{h company_name}".html_safe)
        end
      end
    end
  end
end
