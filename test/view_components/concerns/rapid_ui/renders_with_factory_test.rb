require "test_helper"
require "view_component"
require "spy"

module RapidUI
  class RendersWithFactoryTest < ViewComponent::TestCase
    class IconComponent < ViewComponent::Base
      attr_accessor :name

      def initialize(name, factory:)
        self.name = name
        # self.factory = factory
      end

      def call
        tag.span(name)
      end
    end

    class ItemComponent < ViewComponent::Base
      attr_accessor :name

      def initialize(name, factory:)
        self.name = name
        # self.factory = factory
      end

      def call
        tag.div(name)
      end
    end

    class TestComponent < ViewComponent::Base
      include RendersWithFactory

      renders_one :icon, IconComponent
      renders_many :items, ItemComponent

      def initialize(factory:)
        self.factory = factory
        yield self if block_given?
      end

      def call
        tag.div { safe_join([ icon, items ]) }
      end
    end


    setup do
      @factory = Factory.new
    end

    test "uses factory to build renders_one" do
      factory_spy = Spy.on(@factory, :build)

      TestComponent.new factory: @factory do |c|
        c.with_icon("home")
      end

      assert_equal 1, factory_spy.calls.length
      assert_equal [ IconComponent, "home" ], factory_spy.calls.first.args
    end

    test "uses factory to build renders_many" do
      factory_spy = Spy.on(@factory, :build)

      TestComponent.new factory: @factory do |c|
        c.with_item("item1")
        c.with_item("item2")
      end

      assert_equal 2, factory_spy.calls.length
      assert_equal [ ItemComponent, "item1" ], factory_spy.calls.first.args
      assert_equal [ ItemComponent, "item2" ], factory_spy.calls.second.args
    end

    test "renders_one exposes build method that immediately calls the block" do
      component = TestComponent.new factory: @factory do |c|
        c.build_icon "home" do |icon|
          icon.name = "user"
        end
      end

      assert_instance_of ViewComponent::Slot, component.icon
      assert_equal "user", component.icon.name

      render_inline(component)
      assert_selector "span", text: "user"
    end

    test "renders_many exposes build method that immediately calls the block" do
      component = TestComponent.new factory: @factory do |c|
        c.build_item("item1a") do |item|
          item.name = "item1b"
        end

        c.build_item("item2a") do |item|
          item.name = "item2b"
        end
      end

      assert_instance_of ViewComponent::Slot, component.items.first
      assert_equal "item1b", component.items.first.name
      assert_instance_of ViewComponent::Slot, component.items.second
      assert_equal "item2b", component.items.second.name

      render_inline(component)
      assert_selector "div", text: "item1b"
      assert_selector "div", text: "item2b"
    end
  end

  class RendersWithFactoryProcTest < ViewComponent::TestCase
    class IconComponent < ViewComponent::Base
      attr_accessor :name

      def initialize(name, factory:)
        self.name = name
        # self.factory = factory
      end

      def call
        tag.span(name)
      end
    end

    class ItemComponent < ViewComponent::Base
      attr_accessor :name

      def initialize(name, factory:)
        self.name = name
        # self.factory = factory
      end

      def call
        tag.div(name)
      end
    end

    class TestComponent < ViewComponent::Base
      include RendersWithFactory

      renders_one :icon, ->(name) { build(IconComponent, name) }
      renders_many :items, ->(name) { build(ItemComponent, name) }

      def initialize(factory:)
        self.factory = factory
        yield self if block_given?
      end

      def call
        tag.div { safe_join([ icon, items ]) }
      end
    end

    setup do
      @factory = Factory.new
    end

    test "renders_one proc" do
      component = TestComponent.new factory: @factory do |c|
        c.build_icon "home" do |icon|
          icon.name = "user"
        end
      end

      assert_instance_of ViewComponent::Slot, component.icon
      assert_equal "user", component.icon.name

      render_inline(component)
      assert_selector "span", text: "user"
    end

    test "renders_many proc" do
      component = TestComponent.new factory: @factory do |c|
        c.build_item("item1") do |item|
          item.name = "item1b"
        end

        c.build_item("item2") do |item|
          item.name = "item2b"
        end
      end

      assert_instance_of ViewComponent::Slot, component.items.first
      assert_equal "item1b", component.items.first.name
      assert_instance_of ViewComponent::Slot, component.items.second
      assert_equal "item2b", component.items.second.name

      render_inline(component)
      assert_selector "div", text: "item1b"
      assert_selector "div", text: "item2b"
    end
  end
end
