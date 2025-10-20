module RapidUI
  module Layout
    module Header
      class Components < RapidUI::Components
        contains :search, Search

        contains :dropdown do |name = nil, **kwargs, &block|
          Dropdown.new(name, variant: "primary", **kwargs, &block)
        end

        contains :text do |text, **kwargs, &block|
          Text.new(text, **kwargs, class: merge_classes("header-text", kwargs[:class]), &block)
        end

        contains :text_link do |text, path, **kwargs, &block|
          Button.new(Text.new(text), path:, variant: "primary", **kwargs, &block)
        end

        contains :icon_link do |icon, path, size: nil, **kwargs, &block|
          Button.new(Icon.new(icon, size:), path:, variant: "primary", **kwargs, &block)
        end
      end
    end
  end
end
