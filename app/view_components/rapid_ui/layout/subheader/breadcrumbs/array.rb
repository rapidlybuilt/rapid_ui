module RapidUI
  module Layout
    module Subheader
      module Breadcrumbs
        class Array < ::Array
          Item = Struct.new(:name, :path)

          def new(name, path = nil)
            Item.new(name, path)
          end

          def build(name, path = nil)
            self << new(name, path)
          end
        end
      end
    end
  end
end
