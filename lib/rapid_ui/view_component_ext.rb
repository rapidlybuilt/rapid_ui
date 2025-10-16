require "view_component"
require "view_component/slot"

module RapidUI
  module ViewComponentExt
    module SlotExt
      # HACK: this is a hack to allow blocks to be passed to components
      # which is helpful for setting the content of a component defined inside
      # the initializer of its parent
      def with_content(*args, &block)
        if block_given?
          # this is delegated to the component or
          # raise method_missing (which is saying blocks are not supported)
          with_content_from_block(&block)
        else
          # No block, use the original behavior
          super(*args)
        end
      end
    end
  end
end

# Include the ViewComponent extension
ViewComponent::Slot.prepend(RapidUI::ViewComponentExt::SlotExt)
