require "importmap-rails"
require "turbo-rails"
require "stimulus-rails"

module RapidUI
  class Railtie < ::Rails::Railtie
    # Add the gem's app/views directory to the view paths
    initializer "rapid_ui.views" do |app|
      app.config.paths["app/views"] << File.expand_path("../../app/views", __dir__)
    end

    # Add the gem's app/assets directory to the asset paths
    initializer "rapid_ui.assets" do |app|
      app.config.assets.paths << root.join("app/assets/builds")
      app.config.assets.paths << root.join("app/assets/fonts")
      app.config.assets.paths << root.join("app/assets/images")
      app.config.assets.paths << root.join("app/javascript")

      app.config.assets.precompile += %w[ rapid_ui_manifest.js ]
    end

    initializer "rapid_ui.importmap", before: "importmap" do |app|
      RapidUI.importmap.draw(root.join("config/importmap.rb"))
      if app.config.importmap.sweep_cache && app.config.reloading_enabled?
        RapidUI.importmap.cache_sweeper(watches: root.join("app/javascript"))

        ActiveSupport.on_load(:action_controller_base) do
          before_action { RapidUI.importmap.cache_sweeper.execute_if_updated }
        end
      end
    end

    private

    delegate :root, to: RapidUI
  end
end
