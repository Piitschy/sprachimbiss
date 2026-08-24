// @ts-check
import { defineConfig } from 'astro/config';

// https://astro.build/config
export default defineConfig({
	// Keep every page route directory-based so Nginx can handle all subpages consistently.
	trailingSlash: 'always',
});
