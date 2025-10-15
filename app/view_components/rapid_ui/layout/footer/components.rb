module RapidUI
  module Layout
    module Footer
      class Components < RapidUI::Components
        contains Copyright, :copyright

        contains Button, :text_link do |text, path, **kwargs, &block|
          children = Text.new(text)
          Button.new(children:, path:, additional_class: "footer-btn", **kwargs, &block)
        end

        contains Button, :icon_link do |icon, path, **kwargs, &block|
          children = Icon.new(icon)
          Button.new(children:, path:, additional_class: "footer-btn", **kwargs, &block)
        end
      end
    end
  end
end
