module RapidUI
  module Layout
    module Header
      class Components < RapidUI::Components
        contains :search, Search

        contains :dropdown do |name = nil, **kwargs, &block|
          Dropdown.new(name, variant: "primary", **kwargs, &block)
        end

        contains :text do |text, **kwargs, &block|
          Tag.new(**kwargs, class: merge_classes("header-text", kwargs[:class]), &block).with_content(text)
        end

        contains :text_link do |text, path, **kwargs, &block|
          Button.new(Tag.new.with_content(text), path:, variant: "primary", **kwargs, &block)
        end

        contains :icon_link do |icon, path, size: nil, **kwargs, &block|
          Button.new(Icon.new(icon, size:), path:, variant: "primary", **kwargs, &block)
        end
      end
    end
  end
end
