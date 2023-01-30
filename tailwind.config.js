module.exports = {
  mode: 'jit',
    plugins: [require('@tailwindcss/forms'), require('@tailwindcss/line-clamp'), require('tailwind-capitalize-first-letter'),],
    content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js'
  ]
}
