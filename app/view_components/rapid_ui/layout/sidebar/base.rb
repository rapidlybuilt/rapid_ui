module RapidUI
  module Layout
    module Sidebar
      class Base < ApplicationComponent
        attr_accessor :title

        attr_accessor :closed
        attr_accessor :closed_cookie_name
        attr_accessor :position
        alias_method :closed?, :closed

        # TODO: allow HTML titles
        # renders_one :title, Tag

        renders_one :close_button, ->(sidebar_id, **kwargs) do
          build(
            Button,
            build(Icon, position == :left ? "chevron-left" : "chevron-right"),
            **kwargs,
            title: t(".close_button.title"),
            variant: "naked",
            class: merge_classes("btn-circular size-8", kwargs[:class]),
            data: merge_data({
              action: "click->sidebar#close",
              sidebar_id: id,
            }, kwargs[:data]),
          )
        end

        renders_many_polymorphic(:children,
          navigation: Navigation::Base,
          table_of_contents: TableOfContents::List,
        )

        def initialize(id:, title: nil, closed: nil, position: :left, **kwargs)
          super(
            id:,
            tag_name: :aside,
            **kwargs,
            data: merge_data({
              controller: "sidebar",
            }, kwargs[:data]),
          )

          @id = id.to_s
          @position = position.to_sym

          @title = title
          @closed_cookie_name = "#{@id}_closed"
          @closed = closed

          raise ArgumentError, "#{position} is not a valid position" unless position.in?(%i[ left right ])
        end

        def open?
          !closed?
        end

        def dynamic_css_class
          merge_classes(
            "sidebar",
            "sidebar-#{position}",
            ("open" if open?),
            super,
          )
        end

        def dynamic_data
          merge_data(
            super,
            {
              sidebar_closed_cookie_value: closed_cookie_name,
            },
          )
        end

        def before_render
          with_close_button(id) unless close_button?
          super
        end
      end
    end
  end
end
