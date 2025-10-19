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
        # renders_one :title, Text

        renders_one :close_button, ->(sidebar_id, **kwargs, &block) do
          icon_name = position == :left ? "chevron-left" : "chevron-right"
          Button.new(
            Icon.new(icon_name),
            **kwargs,
            title: t(".close_button.title"),
            variant: "naked",
            class: "btn-circular size-8",
            data: {
              action: "click->sidebar#close",
              sidebar_id: id,
            },
            &block
          )
        end

        renders_one :components, Components

        with_options to: :components do
          delegate :with_navigation
          delegate :with_table_of_contents
        end

        def initialize(id:, title: nil, closed: false, position: :left, **kwargs, &block)
          @id = id.to_s
          @position = position.to_sym
          raise ArgumentError, "#{position} is not a valid position" unless position.in?(%i[ left right ])

          with_close_button(id)
          with_components

          @title = title
          @closed_cookie_name = "#{@id}_closed"
          @closed = closed

          super(
            id:,
            tag_name: :aside,
            **kwargs,
            data: (kwargs[:data] || {}).merge(
              controller: "sidebar",
              sidebar_closed_cookie_value: closed_cookie_name,
            ),
            &block
          )
        end

        # TODO: fix the way this data flows to hide the complexity from the application
        # while not passing cookies around unnecessarily
        def closed?(cookies = nil)
          return closed if cookies.nil?

          cookies[closed_cookie_name] == "1"
        end

        def open?
          !closed?
        end

        def dynamic_css_class
          combine_classes(
            "sidebar",
            "sidebar-#{position}",
            ("open" if open?),
            super,
          )
        end
      end
    end
  end
end
