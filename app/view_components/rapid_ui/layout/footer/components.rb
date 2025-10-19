module RapidUI
  module Layout
    module Footer
      class Components < RapidUI::Components
        contains :copyright, Copyright

        contains :text_link do |text, path, **kwargs, &block|
          Button.new(Text.new(text), path:, additional_class: "footer-btn", **kwargs, &block)
        end

        contains :icon_link do |icon, path, **kwargs, &block|
          Button.new(Icon.new(icon), path:, additional_class: "footer-btn", **kwargs, &block)
        end
      end
    end
  end
end
