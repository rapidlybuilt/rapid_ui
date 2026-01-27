module RapidUI
  module Layout
    module Header
      class SearchBar < ApplicationComponent
        attr_accessor :dynamic_path
        attr_accessor :static_path

        attr_accessor :placeholder
        attr_accessor :shortcut_hint

        attr_accessor :action_title
        attr_accessor :close_title
        attr_accessor :clear_title
        attr_accessor :loading_text
        attr_accessor :error_text
        attr_accessor :empty_results_text

        renders_one :search_icon, ->(**kwargs) do
          build(Icon, "search", **kwargs)
        end

        # TODO: show after an error / during loading
        renders_one :clear_icon, ->(**kwargs) do
          build(Icon, "x", **kwargs)
        end

        renders_one :cancel_button, ->(**kwargs) do
          build(
            Button,
            t(".cancel_button.text"),
            title: t(".cancel_button.title"),
            **kwargs,
            class: merge_classes("btn", kwargs[:class]),
            data: merge_data(kwargs[:data], { action: "click->search#closeDropdown" }),
          )
        end

        renders_one :loading_icon, ->(spin: true, **kwargs) do
          build(Icon, "loader", spin:, **kwargs)
        end

        # TODO: allow rendering any old component in these optional slots
        # renders_one :loading
        # renders_one :error

        def initialize(dynamic_path: nil, static_path: nil, **kwargs)
          super(**kwargs)

          @dynamic_path = dynamic_path
          @static_path = static_path

          @action_title = t(".action")
          @placeholder = t(".placeholder")
          @loading_text = t(".loading_text")
          @error_text = t(".error_text")
          @clear_title = t(".clear_title")
          @close_title = t(".close_title")
          @empty_results_text = t(".empty_results_text")

          # TODO: "Alt" for non-Mac. Hide for Mobile.
          # TODO: drive this key to the component.
          @shortcut_hint = t(".options_shortcut.mac", key: "S")
        end

        def before_render
          with_search_icon unless search_icon?
          with_clear_icon unless clear_icon?
          with_cancel_button unless cancel_button?
          with_loading_icon unless loading_icon?
          super
        end
      end
    end
  end
end
