module RapidUI
  module Layout
    module Header
      class Search < ApplicationComponent
        attr_accessor :path

        attr_accessor :search_icon
        attr_accessor :placeholder
        attr_accessor :shortcut_hint

        attr_accessor :close_icon
        attr_accessor :close_title

        attr_accessor :loading_icon
        attr_accessor :loading_text

        attr_accessor :error_text

        renders_one :loading
        renders_one :error

        def initialize(path: nil)
          @path = path

          @search_icon = Icon.new("search")

          # TODO: show after an error / during loading
          @close_icon = Icon.new("x")
          @loading_icon = Icon.new("loader", spin: true)
          @placeholder = "Search"

          @loading_text = "Searching..."
          @error_text = "Error occurred while searching"
          @close_title = "Close search results"

          # TODO: "Alt" for non-Mac. Hide for Mobile.
          # TODO: drive this key to the component.
          @shortcut_hint = "[Option+S]"
        end
      end
    end
  end
end
