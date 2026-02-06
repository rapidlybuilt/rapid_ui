module RapidUI
  module Datatable
    class << self
      def t(key, table_name:)
        # TODO: rapid_ui.datatable the right namespace for this?
        I18n.t(
          "rapid_ui.datatable.#{table_name}.#{key}",
          default: I18n.t("rapid_ui.datatable.default.#{key}", default: I18n.t("rapid_table.#{table_name}.#{key}", default: I18n.t("rapid_table.default.#{key}", default: nil))),
        )
      end
    end
  end
end
