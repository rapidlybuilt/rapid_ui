pin "application", to: "rapid_ui/application.js", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from RapidUI.root.join("app/javascript/rapid_ui/controllers"), under: "controllers", to: "rapid_ui/controllers"
# pin_all_from MissionControl::Jobs::Engine.root.join("app/javascript/rapid_ui/helpers"), under: "helpers", to: "rapid_ui/helpers"
