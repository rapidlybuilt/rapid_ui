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
          super(tag_name: :footer, **kwargs)
          yield self if block_given?
        end

        def call
          component_tag { safe_join([ left, right ]) }
        end

        class Items < ApplicationComponent
          renders_many :items, ->(type, *args, **kwargs, &block) do
            case type
            when :copyright
              build(Copyright, *args, **kwargs, &block)
            when :text_link
              text, path = *args
              build(Button, build(Tag).with_content(text), path:, **kwargs, class:  merge_classes("footer-btn", kwargs[:class]), &block)
            when :icon_link
              icon, path = *args
              build(Button, build(Icon, icon), path:, **kwargs, class:  merge_classes("footer-btn", kwargs[:class]), &block)
            when :tag
              build(Tag, *args, **kwargs, &block)
            else
              raise ArgumentError, "invalid item type: #{type}"
            end
          end

          def with_copyright(*args, **kwargs, &block)
            with_item(:copyright, *args, **kwargs, &block)
          end

          def with_text_link(*args, **kwargs, &block)
            with_item(:text_link, *args, **kwargs, &block)
          end

          def with_icon_link(*args, **kwargs, &block)
            with_item(:icon_link, *args, **kwargs, &block)
          end

          def with_tag(*args, **kwargs, &block)
            with_item(:tag, *args, **kwargs, &block)
          end

          def build_copyright(*args, **kwargs, &block)
            build_item(:copyright, *args, **kwargs, &block)
          end

          def build_text_link(*args, **kwargs, &block)
            build_item(:text_link, *args, **kwargs, &block)
          end

          def build_icon_link(*args, **kwargs, &block)
            build_item(:icon_link, *args, **kwargs, &block)
          end

          def build_tag(*args, **kwargs, &block)
            build_item(:tag, *args, **kwargs, &block)
          end

          def call
            component_tag { safe_join(items) }
          end
        end
      end
    end
  end
end
