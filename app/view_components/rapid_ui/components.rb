module RapidUI
  # A collection of components to render together
  class Components < ApplicationComponent
    attr_accessor :array
    attr_accessor :separator

    with_options to: :array do
      delegate :any?
      delegate :each
      delegate :map
      delegate :length
      delegate :empty?
      delegate :first
      delegate :last
      delegate :size
      delegate :clear
      delegate :shift
      delegate :pop
      delegate :unshift
      delegate :delete
      delegate :delete_at
      delegate :delete_if
      delegate :reject
      delegate :select
      delegate :sort
      delegate :sort_by
      delegate :sort_by!
      delegate :sort_by!
    end

    def initialize(array = [], separator: "\n")
      @array = array
      @separator = separator
    end

    def <<(component)
      array << safe_component(component)
    end

    def insert(index, component)
      array.insert(index, safe_component(component))
    end

    def push(component)
      array << safe_component(component)
    end

    def call
      return content if empty?

      raise "can't have content and child components" if content? && any?
      safe_join(map { |component| render(component) }, separator)
    end

    def find(component_class)
      array.find { |component| component.is_a?(component_class) }
    end

    class << self
      def contains(component_class, suffix = component_class.name.demodulize.underscore, &block)
        new_method = suffix ? "new_#{suffix}" : "new"
        build_method = suffix ? "build_#{suffix}" : "build"

        block ||= ->(*args, **kwargs, &b) { component_class.new(*args, **kwargs, &b) }
        define_method(new_method, &block)

        define_method(build_method) do |*args, **kwargs, &b|
          instance = send(new_method, *args, **kwargs, &b)
          self << instance
          instance
        end
      end
    end
  end
end
