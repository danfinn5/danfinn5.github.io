# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Hugo static site using the Docsy theme (Google's technical documentation theme) for a technical writing portfolio. Deployed to Netlify. Content includes writing samples, API docs, automation guides, and blog posts.

## Build & Run Commands

```bash
npm install                    # Install dependencies (also runs prebuild to sync submodules)
npm run serve                  # Local dev server with live reload (localhost:1313)
npm run build                  # Dev build (includes drafts/future/expired)
npm run build:production       # Production build (minified + encrypted samples + auth headers)
npm run build:preview          # Preview build (includes drafts + encryption)
npm run test                   # Link checking
npm run clean                  # Remove public/ and resources/
```

Direct Hugo usage:
```bash
hugo server                    # Bare Hugo dev server
hugo --minify --cleanDestinationDir  # Production build
```

## Architecture

- **Content** lives in `content/en/` (primary), with `content/fa/` and `content/no/` for multilingual support
- **Docsy theme** is loaded as a Hugo module (configured in `hugo.toml` under `[module]`), not vendored in the repo
- **Custom layouts** in `layouts/`: protected page template (`_default/protected.html`), PDF viewer shortcode, custom heading renderer, embedded PDF layout
- **Styling** in `assets/scss/`: `_variables_project.scss` for theme variable overrides, `_styles_project.scss` for custom CSS
- **Sample content** behind basic-auth is encrypted via `encrypt-samples.sh` during production builds; auth headers written to `public/_headers` by the `write:headers` script
- **Deployment**: Netlify builds via `netlify.toml` (production command syncs submodules then runs `npm run build:production`). A legacy GitHub Actions workflow (`build.yml`) also exists for GitHub Pages.

## Key Config Files

- `hugo.toml` — Main Hugo config (base URL, languages, theme params, taxonomy, markup settings)
- `netlify.toml` — Netlify build commands and redirects
- `package.json` — npm scripts wrapping Hugo commands; pinned hugo-extended 0.125.7

## Requirements

Hugo Extended 0.110.0+, Node.js LTS, Go (for Hugo module resolution). The `prebuild` script handles git submodule sync automatically.
