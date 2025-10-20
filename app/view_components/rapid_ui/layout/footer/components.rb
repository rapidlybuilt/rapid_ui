module RapidUI
  module Layout
    module Footer
      class Components < RapidUI::Components
        contains :copyright, Copyright

        contains :text_link do |text, path, **kwargs, &block|
          Button.new(Text.new(text), path:, **kwargs, class:  merge_classes("footer-btn", kwargs[:class]), &block)
        end

        contains :icon_link do |icon, path, **kwargs, &block|
          Button.new(Icon.new(icon), path:, **kwargs, class:  merge_classes("footer-btn", kwargs[:class]), &block)
        end
      end
    end
  end
end
