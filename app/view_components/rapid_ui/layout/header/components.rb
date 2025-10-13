module RapidUI
  module Layout
    module Header
      class Components < RapidUI::Components
        def new_icon_button(*args, **kwargs)
          Button.new(*args, **kwargs)
        end

        def build_icon_button(icon, path, **kwargs)
          instance = new_icon_button(nil, path, icon:, **kwargs)
          self << instance
          yield instance if block_given?
          instance
        end

        def new_text_button(*args, **kwargs)
          Button.new(*args, **kwargs)
        end

        def build_text_button(*args, **kwargs)
          instance = new_text_button(*args, **kwargs)
          self << instance
          yield instance if block_given?
          instance
        end

        def new_menu(*args, **kwargs)
          Menu.new(*args, **kwargs)
        end

        def build_menu(*args, **kwargs)
          instance = new_menu(*args, **kwargs)
          self << instance
          yield instance if block_given?
          instance
        end

        def new_text(*args, **kwargs)
          Text.new(*args, **kwargs)
        end

        def build_text(*args, **kwargs)
          instance = new_text(*args, **kwargs)
          self << instance
          yield instance if block_given?
          instance
        end

        def new_search(*args, **kwargs)
          Search.new(*args, **kwargs)
        end

        def build_search(*args, **kwargs)
          instance = new_search(*args, **kwargs)
          self << instance
          yield instance if block_given?
          instance
        end
      end
    end
  end
end
