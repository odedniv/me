/** @type {import('tailwindcss').Config} */
const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
	darkMode: 'class',
	content: ['./src/**/*.{astro,html,js,md,mdx,ts}'],
	theme: {
		extend: {
			colors: {
				white: '#f8f9fa'
			},
			fontFamily: {
				body: ['Manrope', ...defaultTheme.fontFamily.sans]
			},
			gridTemplateColumns: {
				list: 'repeat(auto-fill, minmax(400px, max-content))'
			},
			typography: {
				DEFAULT: {
					css: {
						'blockquote p:first-of-type::before': false,
						'blockquote p:first-of-type::after': false,
					},
				},
			},
		}
	},
	plugins: [require('@tailwindcss/typography')]
}
