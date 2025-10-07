module RapidUI
  class Railtie < ::Rails::Railtie
    # Add the gem's app/views directory to the view paths
    initializer "rapid_ui.views" do |app|
      app.config.paths["app/views"] << File.expand_path("../../app/views", __dir__)
    end

    # Add the gem's app/assets directory to the asset paths
    initializer "rapid_ui.assets" do |app|
      root = Pathname.new(File.expand_path("../../app/assets", __dir__))

      app.config.assets.paths << root.join("builds")
      app.config.assets.paths << root.join("fonts")
      app.config.assets.paths << root.join("images")
      app.config.assets.precompile += %w[ rapid_ui_manifest.js ]
    end
  end
end
