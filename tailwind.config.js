/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './lib/**/*.rb',
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
