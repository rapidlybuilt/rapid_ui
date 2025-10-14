module RapidUI
  module Layout
    module Sidebar
      class CloseButton < Button
        def initialize
          super(
            children: Icon.new("chevron-left"),
            title: t(".title"),
            variant: "naked",
            class: "btn-circular size-8",
            data: {
              action: "click->sidebar#close",
            },
          )
        end
      end
    end
  end
end
