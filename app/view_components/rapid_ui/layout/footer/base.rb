module RapidUI
  module Layout
    module Footer
      class Base < ApplicationComponent
        renders_one :left, ->(**kwargs, &block) do
          build(Items, tag_name: :div, **kwargs, class: merge_classes("footer-left", kwargs[:class]), &block)
        end

        renders_one :right, ->(**kwargs, &block) do
          build(Items, tag_name: :div, **kwargs, class: merge_classes("footer-right", kwargs[:class]), &block)
        end

        def initialize(**kwargs)
          super(tag_name: :footer, **kwargs, class: merge_classes("footer", kwargs[:class]))
          yield self if block_given?
        end

        def call
          component_tag { safe_join([ left, right ]) }
        end

        class Items < ApplicationComponent
          renders_many_polymorphic(:items,
            copyright: Copyright,
            text_link: ->(text, path, **kwargs, &block) {
              build(Button, build(Tag).with_content(text), path:, **kwargs, class:  merge_classes("footer-btn", kwargs[:class]), &block)
            },
            icon_link: ->(icon, path, **kwargs, &block) {
              build(Button, build(Icon, icon), path:, **kwargs, class:  merge_classes("footer-btn", kwargs[:class]), &block)
            },
          )

          def initialize(**kwargs)
            super(**kwargs)
            yield self if block_given?
          end

          def call
            component_tag { safe_join(items) }
          end
        end
      end
    end
  end
end
