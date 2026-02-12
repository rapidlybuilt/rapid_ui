module RapidUI
  module Datatable
    module Support
      module Hotwire
        extend ActiveSupport::Concern

        included do
          include RapidUI::Support::Hotwire
          self.stimulus_controller ||= "datatable"
        end
      end
    end
  end
end
