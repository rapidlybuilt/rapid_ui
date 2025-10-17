module RapidUI
  class ToggleButton < Button
    attr_accessor :on
    alias_method :on?, :on

    attr_accessor :on_class
    attr_accessor :off_class

    attr_accessor :target_id

    def initialize(*children, on: nil, off: nil, on_class: "on", target_id: nil, off_class: nil, **kwargs, &block)
      @on = default_on(on, off)
      @on_class = on_class
      @off_class = off_class
      @target_id = target_id

      # TODO: Stimulus controller for toggling on/off
      super(
        *children,
        **kwargs,
        data: (kwargs.delete(:data) || {}).merge(
          controller: "toggle-button",
          action: "click->toggle-button#toggle",
        ),
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
        (on? ? on_class : off_class),
        super,
      )
    end

    def dynamic_data
      combine_data(
        super,
        {
          toggle_button_target_value: target_id,
          toggle_button_on_class: on_class,
          toggle_button_off_class: off_class,
        },
      )
    end

    private

    def default_on(on, off)
      raise ArgumentError, "cannot provide both on and off" if !on.nil? && !off.nil?
      !on.nil? ? on : (!off.nil? ? !off : false)
    end
  end
end
