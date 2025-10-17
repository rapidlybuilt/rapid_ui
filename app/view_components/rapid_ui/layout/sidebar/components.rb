module RapidUI
  module Layout
    module Sidebar
      class Components < RapidUI::Components
        contains Navigation::Components, :navigation
      end
    end
  end
end
