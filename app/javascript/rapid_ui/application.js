// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Disable prefetching pages on link hover (Turbo Drive still enabled)
document.documentElement.setAttribute("data-turbo-prefetch", "false")
