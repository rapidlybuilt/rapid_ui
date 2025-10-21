module RapidUI
  module Layout
    module Sidebar
      class Components < RapidUI::Components
        contains :navigation, Navigation::Components
        contains :table_of_contents, TableOfContents::List
      end
    end
  end
end
