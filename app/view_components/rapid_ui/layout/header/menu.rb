module RapidUI
  module Layout
    module Header
      class Menu < ApplicationComponent
        attr_accessor :name
        attr_accessor :icon
        attr_accessor :items

        attr_accessor :align_right
        alias_method :align_right?, :align_right

        def initialize(name: nil, icon: "chevron-down", align_right: false, **kwargs)
          super(**kwargs)

          @name = name
          @icon = Icon.new(icon)
          @items = Items.new
          @align_right = align_right
        end

        def dropdown_id
          "#{id}-dropdown" if id
        end

        class Item < ApplicationComponent
          attr_accessor :name
          attr_accessor :path

          def initialize(name, path, additional_class: "header-dropdown-item", **kwargs)
            super(**kwargs)

            @name = name
            @path = path
          end

          def call
            component_tag(:a, name, href: path)
          end
        end

        class Divider < ApplicationComponent
          def call
            component_tag(:hr, class: "header-dropdown-divider")
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
