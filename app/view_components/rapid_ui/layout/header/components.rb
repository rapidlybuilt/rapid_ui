module RapidUI
  module Layout
    module Header
      class Components < RapidUI::Components
        contains Search

        contains Dropdown, :dropdown do |name = nil, icon: "chevron-down", **kwargs|
          Dropdown.new(name, icon: Icon.new(icon), variant: "primary", **kwargs)
        end

        contains Text, :text do |text, **kwargs|
          Text.new(text, additional_class: "header-text", **kwargs)
        end

        contains Button, :text_link do |text, path, **kwargs|
          children = Text.new(text)
          Button.new(children:, path:, variant: "primary", **kwargs)
        end

        contains Button, :icon_link do |icon, path, size: nil, **kwargs|
          children = Icon.new(icon, size:)
          Button.new(children:, path:, variant: "primary", **kwargs)
        end
      end
    end
  end
end
