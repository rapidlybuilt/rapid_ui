module RapidUI
  module Layout
    module Header
      class Components < RapidUI::Components
        contains Menu
        contains Search
        contains Text
        contains Button, :text_button

        contains Button, :icon_button do |icon, path, **kwargs|
          Button.new(nil, path, icon:, **kwargs)
        end
      end
    end
  end
end
