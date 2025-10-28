module RapidUI
  module Forms
    class Groups < ApplicationComponent
      attr_accessor :gap
      attr_accessor :horizontal
      attr_accessor :colspans
      alias_method :horizontal?, :horizontal

      renders_many_polymorphic(:children,
        group: ->(name, colspan: nil, **kwargs) {
          field_id = "#{id}_#{name}"
          key = horizontal ? :content : :group

          build(
            FieldGroup,
            name,
            id: "#{field_id}_group",
            field_id:,
            colspans: colspans.merge(key => colspan || self.colspans[key]),
            horizontal:,
            **kwargs,
          )
        },
        buttons: ->(colspans: self.colspans, **kwargs) {
          build(ButtonsGroup, colspans:, horizontal:, **kwargs)
        }
      )

      # TODO: expose type-specific group builders. i.e. with_text_field_tag_group

      # tailwind include: gap-1 gap-2 gap-3 gap-4 gap-5 gap-6 gap-7 gap-8 gap-9 gap-10 gap-11 gap-12

      def initialize(id, children = [], gap: 3, horizontal: false, colspans: { group: 12, label: 2, content: 10 }, **kwargs)
        super(id:, **kwargs, class: merge_classes("grid grid-cols-12", kwargs[:class]))

        @gap = gap
        @horizontal = horizontal
        @colspans = colspans
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

      def with_checkbox_group(name, **kwargs, &block)
        with_group(name, type: :checkbox, **kwargs, &block)
      end

      def with_radio_button_group(name, **kwargs, &block)
        with_group(name, type: :radio, **kwargs, &block)
      end
    end
  end
end
