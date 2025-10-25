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

        renders_one :search_icon, ->(**kwargs) do
          build(Icon, "search", **kwargs)
        end

        # TODO: show after an error / during loading
        renders_one :close_icon, ->(**kwargs) do
          build(Icon, "x", **kwargs)
        end

        renders_one :loading_icon, ->(spin: true, **kwargs) do
          build(Icon, "loader", spin:, **kwargs)
        end

        # TODO: allow rendering any old component in these optional slots
        # renders_one :loading
        # renders_one :error

        def initialize(path: nil, **kwargs)
          super(**kwargs)

          @path = path

          @placeholder = t(".placeholder")
          @loading_text = t(".loading_text")
          @error_text = t(".error_text")
          @close_title = t(".close_title")

          # TODO: "Alt" for non-Mac. Hide for Mobile.
          # TODO: drive this key to the component.
          @shortcut_hint = t(".options_shortcut.mac", key: "S")
        end

        def before_render
          with_search_icon unless search_icon?
          with_close_icon unless close_icon?
          with_loading_icon unless loading_icon?
          super
        end
      end
    end
  end
end
