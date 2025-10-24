require "test_helper"
require "view_component"
require "spy"

module RapidUI
  class RendersPolymorphicTest < ViewComponent::TestCase
    class ChildComponent < ViewComponent::Base
      attr_accessor :name

      def initialize(name)
        @name = name
      end

      def call
        tag.span(name)
      end
    end

    class TestComponent < ViewComponent::Base
      extend RendersPolymorphic

      renders_many_polymorphic(:items,
        child: ChildComponent,
        text: ->(text, path) { ChildComponent.new("#{text}-#{path}") },
      )

      def call
        tag.div { safe_join(items) }
      end
    end

    test "without syntactic sugar" do
      render_inline TestComponent.new do |c|
        c.with_item(:child, "my name")
        c.with_item(:text, "john", "doe")
      end

      assert_selector "span", text: "my name"
      assert_selector "span", text: "john-doe"
    end

    test "generated with_* methods" do
      render_inline TestComponent.new do |c|
        c.with_child_item("my name")
        c.with_text_item("john", "doe")
      end

      assert_selector "span", text: "my name"
      assert_selector "span", text: "john-doe"
    end

    test "build methods not available when not using factory" do
      component = TestComponent.new
      assert_equal false, component.respond_to?(:build_child_item)
      assert_equal false, component.respond_to?(:build_text_item)
    end
  end

  class RendersPolymorphicWithFactoryTest < ViewComponent::TestCase
    class ChildComponent < ViewComponent::Base
      include RendersWithFactory

      attr_accessor :name

      def initialize(name, factory:)
        @name = name
        self.factory = factory
      end

      def call
        tag.span(name)
      end
    end

    class TestComponent < ViewComponent::Base
      extend RendersPolymorphic
      include RendersWithFactory

      renders_many_polymorphic(:items,
        child: ChildComponent,
        text: ->(text, path) { build(ChildComponent, "#{text}-#{path}") },
      )

      def initialize(factory:)
        self.factory = factory
      end

      def call
        tag.div { safe_join(items) }
      end
    end

    setup do
      @factory = Factory.new
    end

    test "generated build methods" do
      render_inline TestComponent.new(factory: @factory) do |c|
        c.build_child_item("my name")
        c.build_text_item("john", "doe")
      end

      assert_selector "span", text: "my name"
      assert_selector "span", text: "john-doe"
    end

    test "factory is used to generate components" do
      factory_spy = Spy.on(@factory, :build)

      c = TestComponent.new factory: @factory
      c.build_child_item("my name")
      c.build_text_item("john", "doe")

      assert_equal 2, factory_spy.calls.length
      assert_equal [ ChildComponent, "my name" ], factory_spy.calls.first.args
      assert_equal [ ChildComponent, "john-doe" ], factory_spy.calls.second.args
    end
  end

  class RendersPolymorphicSkipSuffixTest < ViewComponent::TestCase
    class ChildComponent < ViewComponent::Base
      attr_accessor :name

      def initialize(name)
        @name = name
      end

      def call
        tag.span(name)
      end
    end

    class TestComponent < ViewComponent::Base
      extend RendersPolymorphic

      renders_many_polymorphic(:items, skip_suffix: true,
        child: ChildComponent,
        text: ->(text, path) { ChildComponent.new("#{text}-#{path}") },
      )

      def call
        tag.div { safe_join(items) }
      end
    end

    test "with_* methods without suffix" do
      c = TestComponent.new
      assert_equal false, c.respond_to?(:with_child_item)
      assert_equal false, c.respond_to?(:with_text_item)

      assert_equal true, c.respond_to?(:with_child)
      assert_equal true, c.respond_to?(:with_text)
    end
  end
end
