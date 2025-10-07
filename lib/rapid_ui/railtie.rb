module RapidUI
  class Railtie < ::Rails::Railtie
    # Add the gem's app/views directory to the view paths
    initializer "rapid_ui.views" do |app|
      app.config.paths["app/views"] << File.expand_path("../../app/views", __dir__)
    end
  end
end
