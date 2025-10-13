module RapidUI
  module Layout
    module Header
      class Menu < ApplicationComponent
        attr_accessor :name
        attr_accessor :icon
        attr_accessor :items
        attr_accessor :css_class

        attr_accessor :align_right
        alias_method :align_right?, :align_right

        def initialize(name: nil, icon: "chevron-down", align_right: false, **kwargs)
          @name = name
          @icon = Icon.new(icon)
          @items = Items.new
          @align_right = align_right
          @css_class = combine_classes(kwargs[:additional_class], kwargs[:class])
        end

        class Item < ApplicationComponent
          attr_accessor :name
          attr_accessor :path
          attr_accessor :css_class

          def initialize(name, path, additional_class: "header-dropdown-item", **kwargs)
            @name = name
            @path = path
            @css_class = combine_classes(additional_class, kwargs[:class])
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
