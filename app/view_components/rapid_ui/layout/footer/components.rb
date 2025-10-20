module RapidUI
  module Layout
    module Footer
      class Components < RapidUI::Components
        contains :copyright, Copyright

        contains :text_link, ->(text, path, **kwargs, &block) do
          build(Button, build(Tag).with_content(text), path:, **kwargs, class:  merge_classes("footer-btn", kwargs[:class]), &block)
        end

        contains :icon_link, ->(icon, path, **kwargs, &block) do
          build(Button, build(Icon, icon), path:, **kwargs, class:  merge_classes("footer-btn", kwargs[:class]), &block)
        end
      end
    end
  end
end
