module RapidUI
  class Alert < ApplicationComponent
    attr_accessor :variant
    attr_accessor :dismissible
    alias_method :dismissible?, :dismissible

    renders_one :icon, Icon
    renders_one :close_button, ->(*args, **kwargs) do
      build(Button, *args, **kwargs).tap do |btn|
        btn.with_content(build(Icon, "x", size: 16))
        btn.tag_name = :button
        btn.css_class = merge_classes(btn.css_class, "alert-close")
        btn.data = merge_data(btn.data, action: "click->dismissible#dismiss") # TODO: only if parent is dismissible
      end
    end

    def initialize(*children, variant: "info", dismissible: false, icon: nil, **kwargs)
      super(
        tag_name: :div,
        **kwargs,
        class: merge_classes("alert", kwargs[:class]),
      )

      with_content(safe_components(*children)) if children.any?
      with_close_button if dismissible

      @variant = variant
      @dismissible = dismissible

      # Auto-build icon if passed as string/symbol
      if icon
        if icon.is_a?(String) || icon.is_a?(Symbol)
          build_icon(icon.to_s, size: 20)
        elsif icon.is_a?(Icon)
          self.icon = icon
        end
      end

      yield self if block_given?
    end

    def dynamic_css_class
      merge_classes(
        super,
        ("alert-#{variant}" if variant),
      )
    end

    def dynamic_data
      merge_data(
        super,
        (dismissible? ? { controller: "dismissible" } : {}),
      )
    end

    def call
      component_tag do
        safe_join([
          (tag.div(render(icon), class: "alert-icon") if icon?),
          tag.div(render(content), class: "alert-content"),
          (close_button if dismissible?),
        ].compact)
      end
    end

    class << self
      def variants
        [ "info", "success", "warning", "danger", "light-primary", "light-secondary", "dark-primary", "dark-secondary" ]
      end
    end
  end
end
