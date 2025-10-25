module RapidUI
  module Layout
    module Header
      class Base < ApplicationComponent
        renders_one :left, ->(**kwargs) do
          build(Items, tag_name: :div, **kwargs, class: merge_classes("header-left", kwargs[:class]))
        end

        renders_one :right, ->(**kwargs) do
          build(Items, tag_name: :div, **kwargs, class: merge_classes("header-right", kwargs[:class]))
        end

        def initialize(**kwargs)
          super(tag_name: :header, **kwargs, class: merge_classes("header", kwargs[:class]))
        end

        def call
          component_tag { safe_join([ left, right ]) }
        end

        class Items < ApplicationComponent
          renders_many_polymorphic(:items,
            search: Search,

            dropdown: ->(*body, **kwargs) {
              build(Dropdown, *body, variant: "primary", **kwargs)
            },

            text: ->(text, **kwargs) {
              build(Tag, tag_name: :span, **kwargs, class: merge_classes("header-text", kwargs[:class])).with_content(text)
            },

            text_link: ->(text, path, **kwargs) {
              build Button, path:, variant: "primary", **kwargs do |btn|
                btn.body << build(Tag).with_content(text)
              end
            },

            icon_link: ->(icon, path, size: nil, **kwargs) {
              build Button, path:, variant: "primary", **kwargs do |btn|
                btn.body << build(Icon, icon, size:)
              end
            },
          )

          def call
            component_tag { safe_join(items) }
          end
        end
      end
    end
  end
end
