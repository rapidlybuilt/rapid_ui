module RapidUI
  module Forms
    module GroupsHelper
      def new_field_groups(*args, **kwargs, &block)
        ui.build Fields::Groups, *args, **kwargs, &block
      end

      def field_groups(*args, **kwargs, &block)
        render new_field_groups(*args, **kwargs), &block
      end
    end
  end
end
