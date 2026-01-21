module RapidUI
  module Forms
    class Groups < ApplicationComponent
      include GroupsTags

      attr_accessor :field_id
      attr_accessor :gap
      attr_accessor :horizontal
      attr_accessor :colspans
      attr_accessor :builder
      alias_method :horizontal?, :horizontal

      renders_many_polymorphic(:children,
        group: ->(name, colspan: nil, **kwargs) {
          field_id = "#{self.field_id}_#{name}"
          key = horizontal ? :content : :group

          build(
            FieldGroup,
            name,
            id: "#{field_id}_group",
            field_id:,
            colspans: colspans.merge(key => colspan || self.colspans[key]),
            horizontal:,
            builder:,
            error: error_messages_for(name),
            **kwargs,
          )
        },
        buttons: ->(colspans: self.colspans, **kwargs) {
          build(ButtonsGroup, colspans:, horizontal:, **kwargs)
        }
      )

      # TODO: expose type-specific group builders. i.e. with_text_field_tag_group

      def initialize(field_id, gap: 3, horizontal: false, colspans: { group: 12, label: 2, content: 10 }, builder: nil, **kwargs)
        super(**kwargs, class: merge_classes("grid grid-cols-12", kwargs[:class]))

        @field_id = field_id
        @gap = gap
        @horizontal = horizontal
        @colspans = colspans
        @builder = builder
      end

      def dynamic_css_class
        merge_classes(
          super,
          ("gap-#{gap}" if gap),
        )
      end

      def call
        component_tag(children.any? ? safe_join(children) : content)
      end

      private

      def error_messages_for(name)
        builder&.object&.errors&.full_messages_for(name)&.join(". ")
      end
    end
  end
end
