module RapidUI
  module Layout
    module Header
      class Components < RapidUI::Components
        contains Menu
        contains Search

        contains Text, :text do |text, **kwargs|
          Text.new(text, additional_class: "header-text", **kwargs)
        end

        contains Button, :text_link do |text, path, **kwargs|
          children = Text.new(text)
          Button.new(children:, path:, additional_class: "header-btn", **kwargs)
        end

        contains Button, :icon_link do |icon, path, size: nil, **kwargs|
          children = Icon.new(icon, size:)
          Button.new(children:, path:, additional_class: "header-btn", **kwargs)
        end
      end
    end
  end
end
