module.exports = {
  mode: 'jit',
    plugins: [require('@tailwindcss/forms'), require('@tailwindcss/line-clamp')],
  purge: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js'
  ]
}
