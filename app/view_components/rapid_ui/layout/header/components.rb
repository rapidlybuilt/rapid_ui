module RapidUI
  module Layout
    module Header
      class Components < RapidUI::Components
        contains :search, Search

        contains :dropdown, ->(name = nil, **kwargs, &block) do
          build(Dropdown, name, variant: "primary", **kwargs, &block)
        end

        contains :text, ->(text, **kwargs, &block) do
          build(Tag, **kwargs, class: merge_classes("header-text", kwargs[:class]), &block).with_content(text)
        end

        contains :text_link, ->(text, path, **kwargs, &block) do
          build(Button, build(Tag).with_content(text), path:, variant: "primary", **kwargs, &block)
        end

        contains :icon_link, ->(icon, path, size: nil, **kwargs, &block) do
          build(Button, build(Icon, icon, size:), path:, variant: "primary", **kwargs, &block)
        end
      end
    end
  end
end
