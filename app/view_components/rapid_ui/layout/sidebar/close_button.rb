module RapidUI
  module Layout
    module Sidebar
      class CloseButton < Button
        def initialize(**kwargs, &block)
          super(
            **kwargs,
            children: Icon.new("chevron-left"),
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
