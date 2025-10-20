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

    def initialize(array = [], tag_name: nil, separator: "\n", **kwargs, &block)
      @array = array
      @separator = separator

      super(tag_name:, **kwargs, &block)
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
      def contains(suffix, class_or_proc)
        raise "use a proc not a block" if block_given?

        new_method = suffix ? "new_#{suffix}" : "new"

        # TODO: decide on the #build naming convention
        build_method = suffix ? "with_#{suffix}" : "build"

        proc = class_or_proc.is_a?(Proc) ? class_or_proc : ->(*args, **kwargs, &b) { class_or_proc.new(*args, **kwargs, &b) }
        define_method(new_method, &proc)

        define_method(build_method) do |*args, **kwargs, &b|
          instance = send(new_method, *args, **kwargs, &b)
          self << instance
          instance
        end
      end
    end
  end
end
