module RapidUI
  module Layout
    module Subheader
      class Base < ApplicationComponent
        renders_one :left, ->(**kwargs, &block) do
          build(Items, tag_name: :div, **kwargs, class: merge_classes("subheader-left", kwargs[:class]), &block)
        end

        renders_one :right, ->(**kwargs, &block) do
          build(Items, tag_name: :div, **kwargs, class: merge_classes("subheader-right", kwargs[:class]), &block)
        end

        with_options to: :breadcrumbs do
          delegate :with_breadcrumb
          delegate :build_breadcrumb
        end

        def initialize(**kwargs)
          super(tag_name: :div, **kwargs, class: merge_classes("subheader", kwargs[:class]))
          yield self if block_given?
        end

        def breadcrumbs
          binding.irb
          left&.find(Breadcrumb::Container) || raise("No breadcrumbs found: have you called #with_breadcrumbs?")
        end

        def call
          component_tag { safe_join([ left, right ]) }
        end

        class Items < ApplicationComponent
          renders_many_polymorphic(:items,
            breadcrumbs: Breadcrumb::Container,

            button: ->(icon, path, variant: "naked", **kwargs, &block) {
              build(Button, build(Icon, icon), path:, variant:, **kwargs, class: merge_classes("subheader-btn", kwargs[:class]), &block)
            },

            sidebar_toggle_button: ->(icon:, circular: false, target: nil, **kwargs, &block) {
              build(
                ToggleButton,
                build(Icon, icon),
                title: t(".sidebar_toggle_button.title"),
                on_class: "btn-outline-primary",
                off_class: "btn-naked",
                target:,
                **kwargs,
                class: merge_classes(circular ? "btn btn-circular size-8" : "btn", kwargs[:class]),
                &block
              )
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
