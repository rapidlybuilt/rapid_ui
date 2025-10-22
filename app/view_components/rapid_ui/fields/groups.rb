module RapidUI
  module Fields
    class Groups < ApplicationComponent
      renders_one :components, "Components"

      with_options to: :components do
        delegate :with_group
        delegate :with_submit_group

        delegate :build_group
        delegate :build_submit_group
      end

      def initialize(id, groups = [], **kwargs)
        super(id:, **kwargs, class: merge_classes("grid grid-cols-12", kwargs[:class]))

        with_components(groups, id:)

        yield self if block_given?
      end

      def call
        component_tag(render(components))
      end

      class Components < Components
        contains :group, ->(name, label_text: nil, col: 12, **kwargs, &block) do
          field_id = "#{id}_#{name}"
          build(Group, name, id: "#{field_id}_group", field_id:, label_text:, col:, **kwargs, &block)
        end

        contains :submit_group, ->(label_text = "Submit", **kwargs, &block) do
          build(SubmitGroup, label_text, **kwargs, &block)
        end
      end
    end
  end
end
