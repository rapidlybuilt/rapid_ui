require "importmap-rails"
require "turbo-rails"
require "stimulus-rails"

module RapidUI
  class Engine < Rails::Engine
    isolate_namespace RapidUI

    initializer "rapid_ui.inflections" do |app|
      Rails.autoloaders.main.inflector.inflect("rapid_ui" => "RapidUI")
    end

    # Add the gem's app/assets directory to the asset paths
    initializer "rapid_ui.assets" do |app|
      if app.config.respond_to?(:assets)
        app.config.assets.paths << root.join("app/assets/builds")
        app.config.assets.paths << root.join("app/assets/fonts")
        app.config.assets.paths << root.join("app/assets/images")
        app.config.assets.paths << root.join("app/javascript")

        app.config.assets.precompile += %w[ rapid_ui_manifest.js ]
      end
    end

    initializer "rapid_ui.importmap", before: "importmap" do |app|
      RapidUI.importmap.draw(root.join("config/importmap.rb"))

      # Set default watch path for RapidUI's JavaScript
      RapidUI.config.importmap.watches << root.join("app/javascript")

      if RapidUI.config.importmap.watches.any? && app.config.reloading_enabled?
        RapidUI.importmap.cache_sweeper(watches: RapidUI.config.importmap.watches)

        ActiveSupport.on_load(:action_controller_base) do
          before_action { RapidUI.importmap.cache_sweeper.execute_if_updated }
        end
      end
    end

    private

    delegate :root, to: RapidUI
  end
end
