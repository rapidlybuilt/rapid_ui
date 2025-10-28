module RapidUI
  class FormBuilder < ActionView::Helpers::FormBuilder
    def field_groups(name = self.object_name, **kwargs, &block)
      @template.render @template.new_form_field_groups(object_name, builder: self, **kwargs), &block
    end
    alias_method :with_field_groups, :field_groups
  end
end
