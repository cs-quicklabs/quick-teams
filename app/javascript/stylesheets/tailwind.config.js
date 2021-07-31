module.exports = {
    purge: [
        './app/**/*.html.erb',
        './app/helpers/**/*.rb',
        './app/javascript/**/*.js'
    ],
    darkMode: false, // or 'media' or 'class'
    theme: {
        extend: {}
    },
    variants: {
        extend: {}
    },
    plugins: [require('@tailwindcss/forms')]
}
module.exports = {
    theme: {
        // ...
    },
    variants: {
        lineClamp: ['responsive', 'hover']
    },
    plugins: [
        require('@tailwindcss/line-clamp')
        // ...
    ]
}