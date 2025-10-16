require "view_component"
require "view_component/slot"

module RapidUI
  module ViewComponentExt
    # This module extends ViewComponent to allow setting component content via an ERB block without rebuilding
    # the component itself.
    #
    # ```erb
    # <% my_component.with_content_from_block do %>
    #   Content that will be captured from ERB
    # <% end %>
    # ```
    #
    # Note: This only works within ERB templates since it relies on Rails' template
    # capturing functionality. It will not work with raw Ruby blocks.
    module WithContentFromBlock
      module BaseExt
        def with_content_from_block(&block)
          if view_context
            with_content(view_context.capture(&block))
          else
            @content_block = block
          end
        end

        def before_render
          return unless @content_block

          with_content(view_context.capture(&@content_block))
          @content_block = nil
        end
      end

      module SlotExt
        # HACK: this is a hack to allow blocks to be passed to components
        # which is helpful for setting the content of a component defined inside
        # the initializer of its parent
        def with_content(*args, &block)
          if block_given?
            # this is delegated to ViewComponent::Base
            with_content_from_block(&block)
          elsif args.length > 1
            # No block, use the original behavior
            super(RapidUI::Components.new(args))
          else
            super(*args)
          end
        end
      end
    end
  end
end

ViewComponent::Base.prepend(RapidUI::ViewComponentExt::WithContentFromBlock::BaseExt)
ViewComponent::Slot.prepend(RapidUI::ViewComponentExt::WithContentFromBlock::SlotExt)
