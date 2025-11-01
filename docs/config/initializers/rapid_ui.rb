# Add docs app's JavaScript directory to the importmap watch paths
RapidUI.config.importmap.watches << RapidUI.root.join("app/javascript")
RapidUI.config.importmap.watches << Rails.root.join("app/javascript")

# Pin docs app controllers to RapidUI's importmap
RapidUI.importmap.draw do |map|
  map.pin_all_from Rails.root.join("app/javascript/controllers"), under: "controllers", to: "controllers", preload: true
end
