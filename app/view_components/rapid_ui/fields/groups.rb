module RapidUI
  module Fields
    class Groups < ApplicationComponent
      attr_accessor :gap

      renders_one :components, "Components"

      with_options to: :components do
        delegate :with_group
        delegate :with_submit_group

        delegate :build_group
        delegate :build_submit_group
      end

      # TODO: fix horizontal: checkboxes, radio buttons are weird. and the label_col API is weird.
      with_options to: :components do
        delegate :horizontal?
        delegate :horizontal=
      end

      # TODO: expose type-specific group builders. i.e. with_text_field_tag_group

      # tailwind include: gap-1 gap-2 gap-3 gap-4 gap-5 gap-6 gap-7 gap-8 gap-9 gap-10 gap-11 gap-12


      def initialize(id, children = [], gap: 3, horizontal: false, label_col: nil, **kwargs)
        raise ArgumentError, "label_col is required for horizontal forms" if horizontal && label_col.nil?

        super(id:, **kwargs, class: merge_classes("grid grid-cols-12", kwargs[:class]))

        @gap = gap
        with_components(children, id:, horizontal:, label_col:)

        yield self if block_given?
      end

      def dynamic_css_class
        merge_classes(
          super,
          ("gap-#{gap}" if gap),
        )
      end

      def call
        component_tag(render(components))
      end

      class Components < Components
        attr_accessor :horizontal
        attr_accessor :label_col

        contains :group, ->(name, col: 12, label_col: self.label_col, **kwargs, &block) do
          field_id = "#{id}_#{name}"
          build(Group, name, id: "#{field_id}_group", field_id:, col:, horizontal:, label_col:, **kwargs, &block)
        end

        contains :submit_group, ->(label_text = "Submit", **kwargs, &block) do
          build(SubmitGroup, label_text, **kwargs, &block)
        end

        def initialize(children = [], horizontal:, label_col:, **kwargs)
          super(children, **kwargs)

          @horizontal = horizontal
          @label_col = label_col
        end
      end
    end
  end
end
