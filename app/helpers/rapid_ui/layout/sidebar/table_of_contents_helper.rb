module RapidUI
  module Layout
    module Sidebar
      module TableOfContentsHelper
        def build_table_of_contents_sidebar(**kwargs, &block)
          sidebar = layout.with_sidebar(id: "table_of_contents", position: :right, title: "On this page")

          # TODO: ensure this is smart merge
          layout.main_container.data.merge!(
            controller: "scrollspy",
            scrollspy_active_class: "active",
          )

          layout.main.data.merge!(
            scrollspy_target: "content",
            action: "scroll->scrollspy#onScroll",
          )

          layout.subheader.right.with_sidebar_toggle_button(
            title: "Toggle table of contents",
            icon: "info",
            target: sidebar,
          )

          toc = sidebar.with_table_of_contents

          builder = Builder.new(self, toc:, **kwargs)
          capture(builder, &block)
        end

        class Builder
          attr_accessor :view_context
          attr_accessor :toc
          attr_accessor :typography
          alias_method :typography?, :typography

          with_options to: :view_context do
            delegate :tag
            delegate :link_to
          end

          def initialize(view_context, toc: nil, typography: false)
            @view_context = view_context
            @toc = toc
            @typography = typography

            # Stack to track current list at each level (indexed by header level - 2)
            # e.g., @list_stack[0] is for h2, @list_stack[1] is for h3, etc.
            @list_stack = [ toc ]
            @last_level = 1 # Start at 1 (before any h2)
          end

          def h1(title, **kwargs)
            css = kwargs[:class] || generate_class(1)
            tag.h1(title, **kwargs, class: css)
          end

          (2..6).each do |number|
            define_method("h#{number}") do |*args, **kwargs|
              header(number, *args, **kwargs)
            end
          end

          def header(number, title, id: generate_id(title), **kwargs)
            path = "##{id}"
            add_to_toc(number, title, path) if toc

            css = RapidUI.merge_classes(kwargs[:class] || generate_class(number), "toc-trigger")

            tag.send(
              :"h#{number}",
              link_to(title, path) << toc_trigger_link(path),
              id:,
              **kwargs,
              class: css,
              data: { scrollspy_target: "trigger" },
            )
          end

          private

          def build_toc_link(title, path)
            current_list.with_link(
              title,
              path,
              data: {
                scrollspy_target: "link",
                action: "click->scrollspy#scrollTo",
              },
            )
          end

          def toc_trigger_link(path)
            link_to("#", path, class: "toc-trigger-link")
          end

          def add_to_toc(level, title, path)
            if level > @last_level
              push_into_toc(level)
            elsif level < @last_level
              pop_out_of_toc(level)
            end

            @last_level = level
            build_toc_link(title, path)
          end

          def current_list(level = @last_level)
            index = current_index(level)
            @list_stack[index]
          end

          # If we're going to a deeper level, we need to create nested lists
          def push_into_toc(level)
            ((@last_level + 1)..level).each do |l|
              idx = l - 2
              parent_idx = idx - 1

              # Only create if it doesn't exist (important for index 0 which is toc)
              unless @list_stack[idx]
                # Create a new nested list in the parent list
                parent_list = @list_stack[parent_idx]
                new_list = parent_list.with_list
                @list_stack[idx] = new_list
              end
            end
          end

          # If we're going to a shallower level, truncate the stack
          # Keep only the levels we need (0 through current_index)
          def pop_out_of_toc(level)
            index = current_index(level)
            @list_stack = @list_stack[0..index]
          end

          # Determine the index in the stack for this level
          # h2 -> index 0 (toc), h3 -> index 1, h4 -> index 2, etc.
          def current_index(level)
            level - 2
          end

          def generate_id(title)
            title.parameterize
          end

          def generate_class(number)
            "typography-h#{number}" if typography?
          end
        end
      end
    end
  end
end
