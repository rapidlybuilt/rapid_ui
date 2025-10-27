module RapidUI
  module Forms
    module GroupsHelper
      def new_form_groups(*args, **kwargs, &block)
        ui.build Forms::Groups, *args, **kwargs, &block
      end

      def form_groups(*args, **kwargs, &block)
        render new_form_groups(*args, **kwargs), &block
      end
    end
  end
end
