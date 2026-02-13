module RapidUI
  module Datatable
    module Support
      # Shortcuts for loading adapters and extensions.
      module Loaders
        extend ActiveSupport::Concern

        module ClassMethods
          def adapter(adapter)
            include Adapters.const_get(adapter.to_s.camelize)
          end

          def extension(extension)
            include Extensions.const_get(extension.to_s.camelize)
          end
        end
      end
    end
  end
end
