module RapidUI
  module Layout
    module Subheader
      class Breadcrumb < ApplicationComponent
        attr_accessor :name
        attr_accessor :path

        def initialize(name, path = nil, **kwargs)
          super(tag_name: :a, **kwargs)

          @name = name
          @path = path
        end

        def call
          return tag.span(name) if path.blank?

          component_tag(name, href: path)
        end

        class Container < ApplicationComponent
          # HACK: don't manually generate this HTML separator
          SEPARATOR = %(<span class="px-3px">&raquo;</span>).html_safe.freeze

          attr_accessor :separator
          attr_accessor :mode

          renders_many :breadcrumbs, ->(*args, **kwargs) {
            build(Breadcrumb, *args, **kwargs)
          }

          renders_one :small_dropdown, ->(**kwargs) {
            build(Dropdown, variant: nil, **kwargs)
          }

          renders_one :tiny_dropdown, ->(**kwargs) {
            build(Dropdown, variant: nil, **kwargs)
          }

          def initialize(*args, separator: SEPARATOR, mode: nil, **kwargs)
            super(
              *args,
              tag_name: :div,
              **kwargs,
              class: merge_classes("subheader-breadcrumbs", kwargs[:class]),
              data: merge_data({
                controller: "breadcrumbs",
              }, kwargs[:data]),
            )

            @separator = separator
            @mode = mode
          end

          def call
            # three ways to display the breadcrumbs depending on the screen size
            contents = []
            contents << flat_container
            contents << small_container
            contents << tiny_container

            component_tag { safe_join(contents) }
          end

          private

          def before_render
            super

            unless breadcrumbs.empty?
              init_tiny_dropdown unless tiny_dropdown?
              init_small_dropdown unless small_dropdown?
            end
          end

          def init_tiny_dropdown
            with_tiny_dropdown(align: "center").tap do |dropdown|
              dropdown.with_button(build(Dropdown::ArrowIcon), breadcrumbs.last.name, skip_caret: true)
              dropdown.with_menu do |menu|
                breadcrumbs.each do |breadcrumb|
                  menu.with_item(breadcrumb.name, breadcrumb.path)
                end
              end
            end
          end

          def init_small_dropdown
            with_small_dropdown(align: "center").tap do |dropdown|
              dropdown.with_button("...", skip_caret: true)
              dropdown.with_menu do |menu|
                breadcrumbs[1..-2].each do |breadcrumb|
                  menu.with_item(breadcrumb.name, breadcrumb.path)
                end
              end
            end
          end

          def flat_container
            tag.div(
              safe_join(breadcrumbs, separator),
              data: { breadcrumbs_target: "flat" },
              class: mode_container_class(:flat),
            )
          end

          def small_container
            tag.div(
              small_contents,
              data: { breadcrumbs_target: "small" },
              class: mode_container_class(:small),
            )
          end

          def tiny_container
            tag.div(
              tiny_dropdown,
              data: { breadcrumbs_target: "tiny" },
              class: mode_container_class(:tiny),
            )
          end

          def mode_container_class(mode)
            css = "subheader-breadcrumbs-#{mode}"
            return css if mode == self.mode

            merge_classes(css, "hidden")
          end

          def small_contents
            contents = []
            contents << breadcrumbs.first
            contents << small_dropdown
            contents << breadcrumbs.last

            safe_join(contents, separator)
          end
        end
      end
    end
  end
end
