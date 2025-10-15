module RapidUI
  module Layout
    module Header
      class Components < RapidUI::Components
        contains Search

        contains Dropdown, :dropdown do |name = nil, icon: "chevron-down", **kwargs, &block|
          Dropdown.new(name, icon: Icon.new(icon), variant: "primary", **kwargs, &block)
        end

        contains Text, :text do |text, **kwargs, &block|
          Text.new(text, additional_class: "header-text", **kwargs, &block)
        end

        contains Button, :text_link do |text, path, **kwargs, &block|
          children = Text.new(text)
          Button.new(children:, path:, variant: "primary", **kwargs, &block)
        end

        contains Button, :icon_link do |icon, path, size: nil, **kwargs, &block|
          children = Icon.new(icon, size:)
          Button.new(children:, path:, variant: "primary", **kwargs, &block)
        end
      end
    end
  end
end
