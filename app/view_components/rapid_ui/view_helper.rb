module RapidUI
  class ViewHelper < ApplicationComponent
    attr_accessor :method_name
    attr_accessor :args
    attr_accessor :kwargs
    attr_accessor :block

    def initialize(method_name, *args, factory: nil, **kwargs, &block)
      @method_name = method_name
      @args = args
      @kwargs = kwargs
      @block = block
    end

    def call
      view_context.send(method_name, *args, **kwargs, &block)
    end
  end
end
