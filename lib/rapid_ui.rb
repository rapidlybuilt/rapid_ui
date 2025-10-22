require "rapid_ui/version"
require "rapid_ui/engine"

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect("rapid_ui" => "RapidUI")
loader.setup

module RapidUI
  mattr_accessor :importmap, default: Importmap::Map.new

  class << self
    def root
      Pathname.new(File.expand_path("..", __dir__))
    end

    # TODO: move these to their own utility module.
    def merge_classes(css_class, *more_classes)
      return css_class if more_classes.empty? # optimize for common scenerio

      result = [ css_class, *more_classes ].compact.join(" ")
      result if result.present?
    end

    def merge_data(data1, data2)
      data1 ||= {}
      return data1 unless data2&.any? # optimize for common scenerio

      data1.merge(
        **data2,
        controller: merge_data_controller(data1[:controller], data2[:controller]),
        action: merge_data_action(data1[:action], data2[:action]),
      )
    end

    def merge_attributes(attributes1, **attributes2)
      return attributes1 if attributes2.empty? # optimize for common scenerio

      attributes1.merge(
        **attributes2,
        class: merge_classes(attributes1[:class], attributes2[:class]),
        data: merge_data(attributes1[:data], attributes2[:data]),
      )
    end

    def merge_data_controller(controller1, controller2)
      # optimize for common scenerios
      return controller1 if controller2.blank?
      return controller2 if controller1.blank?

      [ controller1, controller2 ].join(" ")
    end

    def merge_data_action(action1, action2)
      # optimize for common scenerios
      return action1 if action2.blank?
      return action2 if action1.blank?

      [ action1, action2 ].join(" ")
    end
  end
end
