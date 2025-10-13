module RapidUI
  module Layout
    module Header
      class Menu < ApplicationComponent
        attr_accessor :name
        attr_accessor :icon
        attr_accessor :items

        attr_accessor :align_right
        alias_method :align_right?, :align_right

        def initialize(name: nil, icon: "chevron-down")
          @name = name
          @icon = Icon.new(icon)
          @items = Items.new
        end

        class Item < ApplicationComponent
          attr_accessor :name
          attr_accessor :path
          attr_accessor :css_class

          def initialize(name, path, css_class: "header-dropdown-item")
            @name = name
            @path = path
            @css_class = css_class
          end

          def call
            link_to(name, path, class: css_class)
          end
        end

        class Divider < ApplicationComponent
          def call
            tag.hr(class: "header-dropdown-divider")
          end
        end

        class Items < Components
          contains Item, nil
          contains Divider, :divider
        end
      end
    end
  end
end
