module.exports = {
  mode: 'jit',
  plugins: [require('@tailwindcss/forms'), require('tailwind-capitalize-first-letter'),],
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js'
  ]
}
