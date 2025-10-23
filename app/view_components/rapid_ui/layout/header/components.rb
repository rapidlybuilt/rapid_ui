module RapidUI
  module Layout
    module Header
      class Components < RapidUI::Components
        contains :search, Search

        contains :dropdown, ->(*body, **kwargs) do
          build(Dropdown, *body, variant: "primary", **kwargs)
        end

        contains :text, ->(text, **kwargs) do
          build(Tag, **kwargs, class: merge_classes("header-text", kwargs[:class])).with_content(text)
        end

        contains :text_link, ->(text, path, **kwargs) do
          build(Button, path:, variant: "primary", **kwargs) do |btn|
            btn.body << build(Tag).with_content(text)
          end
        end

        contains :icon_link, ->(icon, path, size: nil, **kwargs) do
          build(Button, path:, variant: "primary", **kwargs) do |btn|
            btn.body << build(Icon, icon, size:)
          end
        end
      end
    end
  end
end
