module RapidUI
  module Layout
    module Sidebar
      class CloseButton < Button
        def initialize(**kwargs, &block)
          super(
            Icon.new("chevron-left"),
            **kwargs,
            title: t(".title"),
            variant: "naked",
            class: "btn-circular size-8",
            data: {
              action: "click->sidebar#close",
            },
            &block
          )
        end
      end
    end
  end
end
