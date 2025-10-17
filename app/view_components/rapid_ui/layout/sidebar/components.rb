module RapidUI
  module Layout
    module Sidebar
      class Components < RapidUI::Components
        contains Navigation::Base, :navigation
      end
    end
  end
end
