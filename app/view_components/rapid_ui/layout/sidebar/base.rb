module RapidUI
  module Layout
    module Sidebar
      class Base < ApplicationComponent
        attr_accessor :title

        attr_accessor :close_button
        attr_accessor :closed
        attr_accessor :closed_cookie_name
        alias_method :closed?, :closed

        attr_accessor :contents

        def initialize(**kwargs, &block)
          @close_button = CloseButton.new
          @closed_cookie_name = "sidebar_closed"
          @closed = false

          @contents = Components.new

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

        def build_navigation(*args, **kwargs, &block)
          navigation = Navigation::Base.new(*args, **kwargs)
          block.call(navigation) if block
          @contents << navigation
        end
      end
    end
  end
end
