module RapidUI
  module Layout
    module Footer
      class Base < ApplicationComponent
        renders_one :left, ->(**kwargs) do
          build(Items, tag_name: :div, **kwargs, class: merge_classes("footer-left", kwargs[:class]))
        end

        renders_one :right, ->(**kwargs) do
          build(Items, tag_name: :div, **kwargs, class: merge_classes("footer-right", kwargs[:class]))
        end

        def initialize(**kwargs)
          super(tag_name: :footer, **kwargs, class: merge_classes("footer", kwargs[:class]))
        end

        def call
          component_tag { safe_join([ left, right ]) }
        end

        class Items < ApplicationComponent
          renders_many_polymorphic(:items,
            copyright: Copyright,
            text_link: ->(text, path, **kwargs) {
              build(Button, build(Tag).with_content(text), path:, **kwargs, class:  merge_classes("footer-btn", kwargs[:class]))
            },
            icon_link: ->(icon, path, **kwargs) {
              build(Button, build(Icon, icon), path:, **kwargs, class:  merge_classes("footer-btn", kwargs[:class]))
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
