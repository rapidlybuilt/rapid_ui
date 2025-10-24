module RapidUI
  class Alert < ApplicationComponent
    include HasBodyContent

    attr_accessor :variant
    attr_accessor :dismissible
    alias_method :dismissible?, :dismissible

    renders_one :icon, Icon

    renders_one :close_button, ->(*body, **kwargs, &block) do
      build(Button, **kwargs) do |btn|
        btn.css_class = merge_classes(btn.css_class, "alert-close")
        btn.data = merge_data(btn.data, action: "click->dismissible#dismiss")
      end
    end

    def initialize(*body, variant: "info", icon: nil, dismissible: false, **kwargs)
      super(
        tag_name: :div,
        **kwargs,
        class: merge_classes("alert", kwargs[:class]),
      )

      self.body = body
      @variant = variant
      @dismissible = dismissible

      with_icon(icon) if icon

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
          (tag.div(icon, class: "alert-icon") if icon?),
          tag.div(content, class: "alert-content"),
          close_button,
        ].compact)
      end
    end

    private

    def before_render
      with_close_button if dismissible?
      super
    end

    def with_body_content
      close_button.body << build(Icon, "x", size: 16) if dismissible?
      super
    end

    class << self
      def variants
        [
          "info", "success", "warning", "danger",
          "light-primary", "light-secondary", "dark-primary", "dark-secondary",
        ]
      end
    end
  end
end
