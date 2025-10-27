require "test_helper"
require "view_component"

module RapidUI
  class ViewComponentTestCase < ViewComponent::TestCase
    def factory
      @factory ||= Factory.new
    end

    def build(*args, factory: self.factory, **kwargs)
      component = described_class.new(*args, factory: factory, **kwargs)
      yield component if block_given?
      component
    end

    def described_class
      self.class.described_class
    end

    class << self
      def described_class(klass = nil)
        @described_class = klass if klass
        @described_class
      end
    end
  end
end
