module.exports = {
  mode: 'jit',
  plugins: [require('@tailwindcss/forms')],
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js'
  ]
}
