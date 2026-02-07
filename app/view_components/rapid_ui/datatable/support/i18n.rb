module RapidUI
  module Datatable
    module Support
      module I18n
        extend ActiveSupport::Concern

        included do
          extend ClassMethods

          attr_accessor :table_name
        end

        def t(*keys)
          self.class.t(keys.join("."), table_name:)
        end

        module ClassMethods
          def t(key, table_name:)
            Datatable.t(key, table_name:)
          end

          def table_name
            name&.underscore
          end
        end
      end
    end
  end
end
