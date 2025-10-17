module RapidUI
  class ToggleButton < Button
    attr_accessor :on
    alias_method :on?, :on

    attr_accessor :on_class

    def initialize(*children, on: false, on_class: "on", **kwargs, &block)
      @closed = false
      @on_class = on_class

      # TODO: Stimulus controller for toggling on/off
      super(
        *children,
        **kwargs,
        &block
      )
    end

    def off?
      !on?
    end

    def off=(b)
      self.on = !b
    end

    def dynamic_css_class
      combine_classes(
        (on_class unless on?),
        super,
      )
    end
  end
end
