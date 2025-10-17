module RapidUI
  class ToggleButton < Button
    attr_accessor :on
    alias_method :on?, :on

    attr_accessor :on_class

    def initialize(*children, on: nil, off: nil, on_class: "on", **kwargs, &block)
      @closed = default_closed(on, off)

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

    private

    def default_closed(on, off)
      raise ArgumentError, "cannot provide both on and off" if !on.nil? && !off.nil?
      !on.nil? ? !on : (!off.nil? ? !off : false)
    end
  end
end
