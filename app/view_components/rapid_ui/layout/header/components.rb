module RapidUI
  module Layout
    module Header
      class Components < RapidUI::Components
        contains Search

        contains Dropdown, :dropdown do |name = nil, **kwargs, &block|
          Dropdown.new(name, variant: "primary", **kwargs, &block)
        end

        contains Text, :text do |text, **kwargs, &block|
          Text.new(text, additional_class: "header-text", **kwargs, &block)
        end

        contains Button, :text_link do |text, path, **kwargs, &block|
          Button.new(Text.new(text), path:, variant: "primary", **kwargs, &block)
        end

        contains Button, :icon_link do |icon, path, size: nil, **kwargs, &block|
          Button.new(Icon.new(icon, size:), path:, variant: "primary", **kwargs, &block)
        end
      end
    end
  end
end
