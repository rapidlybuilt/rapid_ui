module RapidUI
  # A collection of components to render together
  class Components < ApplicationComponent
    attr_accessor :array

    with_options to: :array do
      delegate :<<
      delegate :each
      delegate :map
    end

    def initialize(component_class, array = [])
      @component_class = component_class
      @array = array
    end

    def new(*args, **kwargs)
      @component_class.new(*args, **kwargs)
    end

    def build(*args, **kwargs)
      instance = new(*args, **kwargs)
      self << instance
      instance
    end

    def call
      safe_join(map { |component| render(component) })
    end
  end
end
