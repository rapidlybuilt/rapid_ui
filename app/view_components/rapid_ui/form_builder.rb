module RapidUI
  class FormBuilder < ActionView::Helpers::FormBuilder
    def with_field_groups(name = self.object_name, **kwargs, &block)
      @template.render @template.new_form_field_groups(object_name, builder: self, **kwargs), &block
    end
    alias_method :field_groups, :with_field_groups
  end
end
