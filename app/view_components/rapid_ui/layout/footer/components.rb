module RapidUI
  module Layout
    module Footer
      class Components < RapidUI::Components
        contains Copyright, :copyright

        contains Button, :text_link do |text, path, **kwargs|
          children = Text.new(text)
          Button.new(children:, path:, additional_class: "footer-btn", **kwargs)
        end

        contains Button, :icon_link do |icon, path, **kwargs|
          children = Icon.new(icon)
          Button.new(children:, path:, additional_class: "footer-btn", **kwargs)
        end
      end
    end
  end
end
