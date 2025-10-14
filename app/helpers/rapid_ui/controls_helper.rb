module RapidUI
  module ControlsHelper
    def self.included(base)
      base.include ApplicationHelper

      base.include Controls::ButtonsHelper
      base.include Controls::DropdownsHelper
    end
  end
end
