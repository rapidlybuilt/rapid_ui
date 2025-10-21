module RapidUI
  # A collection of components to render together
  class Components < ApplicationComponent
    attr_accessor :array
    attr_accessor :separator

    with_options to: :array do
      delegate :[]
      delegate :[]=
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

    def initialize(array = [], tag_name: nil, separator: "\n", **kwargs)
      super(tag_name:, **kwargs)

      @array = array
      @separator = separator

      yield self if block_given?
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
      body = safe_join(map { |component| render(component) }, separator)

      dynamic_tag_name ? component_tag(body) : body
    end

    def find(component_class)
      array.find { |component| component.is_a?(component_class) }
    end

    class << self
      def contains(name, class_or_proc)
        raise "use a proc not a block" if block_given?
        raise "name must be a symbol" unless name.is_a?(Symbol)

        new_method = "new_#{name}"
        build_method = "build_#{name}"

        proc = class_or_proc.is_a?(Proc) ? class_or_proc : ->(*args, **kwargs, &b) { build(class_or_proc, *args, **kwargs, &b) }
        define_method(new_method, &proc)

        define_method(build_method) do |*args, **kwargs, &b|
          instance = send(new_method, *args, **kwargs, &b)
          self << instance
          instance
        end

        # with is the ViewComponent::Base API
        alias_method :"with_#{name}", :"build_#{name}"
      end
    end
  end
end
