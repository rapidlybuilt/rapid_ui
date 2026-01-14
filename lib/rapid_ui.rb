require "rapid_ui/version"
require "rapid_ui/engine"

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  "rapid_ui" => "RapidUI",
  "tailwind_css" => "TailwindCSS",
)
loader.setup

module RapidUI
  mattr_accessor :importmap, default: Importmap::Map.new
  mattr_accessor :config, default: Config.new

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

      merged = data1.merge(data2)

      controller = merge_data_controller(data1[:controller], data2[:controller])
      merged[:controller] = controller if controller.present?

      action = merge_data_action(data1[:action], data2[:action])
      merged[:action] = action if action.present?

      merged
    end

    def merge_attributes(attributes1, attributes2)
      return attributes1 unless attributes2&.any? # optimize for common scenerio

      merged = attributes1.merge(attributes2)

      css = merge_classes(attributes1[:class], attributes2[:class])
      merged[:class] = css if css.present?

      data = merge_data(attributes1[:data], attributes2[:data])
      merged[:data] = data if data.present?

      merged
    end

    def merge_data_controller(controller1, *more_controllers)
      return controller1 if more_controllers.empty? # optimize for common scenerio

      controllers = [ controller1, *more_controllers ].compact
      controllers.join(" ") if controllers.any?
    end

    def merge_data_action(action1, *more_actions)
      return action1 if more_actions.empty? # optimize for common scenerio

      actions = [ action1, *more_actions ].compact
      actions.join(" ") if actions.any?
    end
  end
end
