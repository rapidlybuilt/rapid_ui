module RapidUI
  module Datatable
    module Support
      module HasTableTag
        extend ActiveSupport::Concern

        included do
          include RapidUI::Support::Config

          config_attribute :striped, default: false
          config_attribute :hover, default: false
          config_attribute :bordered, default: false
          config_attribute :borderless, default: false
          config_attribute :small, default: false
          config_attribute :responsive, default: false
          config_attribute :align, default: nil
        end

        def table_tag(**kwargs, &block)
          table = tag.table(**kwargs, class: merge_classes(table_tag_css_class, kwargs[:class]), &block)

          if responsive?
            tag.div(table, class: table_tag_responsive_class)
          else
            table
          end
        end

        def thead_row_tag(**kwargs, &block)
          tag.tr(**kwargs, &block)
        end

        private

        def table_tag_css_class
          # TODO: DRY this up with RapidUI::Table
          merge_classes(
            "table",
            ("table-striped" if striped?),
            ("table-hover" if hover?),
            ("table-bordered" if bordered?),
            ("table-borderless" if borderless?),
            ("table-sm" if small?),
            ("table-align-#{align}" if align),
          )
        end

        def table_tag_responsive_class
          case responsive
          when true, "always"
            "table-responsive"
          when String
            "table-responsive-#{responsive}"
          else
            "table-responsive"
          end
        end
      end
    end
  end
end
