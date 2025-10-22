module RapidUI
  module Layout
    module Header
      class Components < RapidUI::Components
        contains :search, Search

        contains :dropdown, ->(*body, **kwargs, &block) do
          build(Dropdown, variant: "primary", **kwargs) do |d|
            new_component_content(d, body, &block)
          end
        end

        contains :text, ->(text, **kwargs, &block) do
          build(Tag, **kwargs, class: merge_classes("header-text", kwargs[:class]), &block).with_content(text)
        end

        contains :text_link, ->(text, path, **kwargs) do
          build(Button, path:, variant: "primary", **kwargs) do |btn|
            new_component_content(btn, [ build(Tag).with_content(text) ])
          end
        end

        contains :icon_link, ->(icon, path, size: nil, **kwargs) do
          build(Button, path:, variant: "primary", **kwargs) do |btn|
            new_component_content(btn, [ build(Icon, icon, size:) ])
          end
        end
      end
    end
  end
end
