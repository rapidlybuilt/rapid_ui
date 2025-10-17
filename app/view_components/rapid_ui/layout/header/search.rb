module RapidUI
  module Layout
    module Header
      class Search < ApplicationComponent
        attr_accessor :path

        attr_accessor :placeholder
        attr_accessor :shortcut_hint

        attr_accessor :close_title
        attr_accessor :loading_text
        attr_accessor :error_text

        renders_one :search_icon, ->(**kwargs, &block) do
          Icon.new("search", **kwargs, &block)
        end

        # TODO: show after an error / during loading
        renders_one :close_icon, ->(**kwargs, &block) do
          Icon.new("x", **kwargs, &block)
        end

        renders_one :loading_icon, ->(spin: true, **kwargs, &block) do
          Icon.new("loader", spin:, **kwargs, &block)
        end

        renders_one :loading
        renders_one :error

        def initialize(path: nil, **kwargs, &block)
          with_search_icon
          with_close_icon
          with_loading_icon

          @path = path

          # TODO: show after an error / during loading
          @placeholder = t(".placeholder")
          @loading_text = t(".loading_text")
          @error_text = t(".error_text")
          @close_title = t(".close_title")

          # TODO: "Alt" for non-Mac. Hide for Mobile.
          # TODO: drive this key to the component.
          @shortcut_hint = t(".options_shortcut.mac", key: "S")

          super(**kwargs, &block)
        end
      end
    end
  end
end
