module RapidUI
  module Forms
    module FieldGroupsHelper
      def new_form_field_groups(*args, **kwargs, &block)
        ui.build Forms::Groups, *args, **kwargs, &block
      end

      def form_field_groups(*args, **kwargs, &block)
        render new_form_field_groups(*args, **kwargs), &block
      end
    end
  end
end
