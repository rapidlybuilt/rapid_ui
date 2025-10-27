module RapidUI
  module Fields
    class Groups < ApplicationComponent
      attr_accessor :gap
      attr_accessor :horizontal
      attr_accessor :label_col
      alias_method :horizontal?, :horizontal

      renders_many_polymorphic(:children,
        group: ->(name, col: 12, label_col: self.label_col, **kwargs) {
          field_id = "#{id}_#{name}"
          build(Group, name, id: "#{field_id}_group", field_id:, col:, horizontal:, label_col:, **kwargs)
        },
        buttons: ->(col: 12, label_col: self.label_col, **kwargs) {
          build(ButtonsGroup, col:, horizontal:, label_col:, **kwargs)
        }
      )

      # TODO: expose type-specific group builders. i.e. with_text_field_tag_group

      # tailwind include: gap-1 gap-2 gap-3 gap-4 gap-5 gap-6 gap-7 gap-8 gap-9 gap-10 gap-11 gap-12

      def initialize(id, children = [], gap: 3, horizontal: false, label_col: nil, **kwargs)
        raise ArgumentError, "label_col is required for horizontal forms" if horizontal && label_col.nil?

        super(id:, **kwargs, class: merge_classes("grid grid-cols-12", kwargs[:class]))

        @gap = gap
        @horizontal = horizontal
        @label_col = label_col
      end

      def dynamic_css_class
        merge_classes(
          super,
          ("gap-#{gap}" if gap),
        )
      end

      def call
        component_tag(safe_join(children))
      end
    end
  end
end
