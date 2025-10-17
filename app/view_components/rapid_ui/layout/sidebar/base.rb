module RapidUI
  module Layout
    module Sidebar
      class Base < ApplicationComponent
        attr_accessor :title

        attr_accessor :closed
        attr_accessor :closed_cookie_name
        alias_method :closed?, :closed

        # TODO: allow HTML titles
        # renders_one :title, Text

        renders_one :close_button, ->(**kwargs, &block) do
          Button.new(
            Icon.new("chevron-left"),
            **kwargs,
            title: t(".title"),
            variant: "naked",
            class: "btn-circular size-8",
            data: {
              action: "click->sidebar#close",
            },
            &block
          )
        end

        renders_one :components, Components

        with_options to: :components do
          delegate :build_navigation
        end

        def initialize(title: nil, closed: false, **kwargs, &block)
          with_close_button
          with_components

          @title = title
          @closed_cookie_name = "sidebar_closed"
          @closed = closed

          super(tag_name: :aside, **kwargs, &block)
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
            ("open" if open?),
            super,
          )
        end
      end
    end
  end
end
