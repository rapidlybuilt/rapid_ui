module RapidUI
  module Layout
    module Sidebar
      class CloseButton < Button
        def initialize
          super(
            nil,
            icon: "chevron-left",
            title: t(".title"),
            class: "btn btn-naked btn-circular size-8",
            data: {
              action: "click->sidebar#close",
            },
          )
        end
      end
    end
  end
end
