module RapidUI
  module Layout
    module Sidebar
      class Components < RapidUI::Components
        contains Navigation::Components, :navigation
        contains TableOfContents::List, :table_of_contents
      end
    end
  end
end
