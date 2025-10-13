module RapidUI
  module Layout
    module Header
      class Components < RapidUI::Components
        contains Menu
        contains Search
        contains Text

        contains Button, :text_link do |name, path, **kwargs|
          Button.new(name, path:, additional_class: "header-btn", **kwargs)
        end

        contains Button, :icon_link do |icon, path, size: nil, **kwargs|
          button = Button.new(nil, path:, icon:, additional_class: "header-btn", **kwargs)
          button.icon.size = size if size
          button
        end
      end
    end
  end
end
