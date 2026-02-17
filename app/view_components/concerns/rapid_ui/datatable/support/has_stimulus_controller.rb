module RapidUI
  module Datatable
    module Support
      module HasStimulusController
        extend ActiveSupport::Concern

        included do
          include RapidUI::Support::HasStimulusController
          self.stimulus_controller ||= "datatable"
        end
      end
    end
  end
end
