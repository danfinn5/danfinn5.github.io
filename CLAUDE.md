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

- **Content** lives in `content/en/` (primary), with `content/fa/` and `content/no/` for multilingual support. Sections: `docs/`, `blog/`, `about/`.
- **Docsy theme** is loaded as a Hugo module (configured in `hugo.toml` under `[module]`), not vendored in the repo.
- **Custom layouts** in `layouts/`: protected page template (`_default/protected.html`), PDF viewer shortcode (`shortcodes/pdf-viewer/`), custom heading renderer (`_default/_markup/render-heading.html`), embedded PDF layout (`embedpdf.html`).
- **Styling** in `assets/scss/`: `_variables_project.scss` for theme variable overrides, `_styles_project.scss` for custom CSS. Prefix custom partials with `_`.
- **PDFs** served from `static/pdfs/` (a git submodule). Netlify build syncs submodules automatically.
- **Sample encryption**: `encrypt-samples.sh` encrypts specific pages under `docs/writing_samples/` using Staticrypt. Controlled by `ENABLE_ENCRYPT` env var (disabled by default on Netlify). Auth headers for `/samples/*` and `/pdfs/*` written to `public/_headers` by the `write:headers` script using `SAMPLES_BASIC_AUTH` env var.
- **Deployment**: Netlify builds via `netlify.toml` (production command syncs submodules then runs `npm run build:production`). Legacy GitHub Actions workflows (`build.yml`, `hugodeploy.yml`) exist but are not the primary deployment path.

## Content Conventions

- Use Hugo front matter (YAML) at the top of markdown files.
- Follow Docsy content types: `docs/`, `blog/`, `about/`.
- Use Hugo shortcodes for special content (alerts, tabs, etc.).
- Override theme templates by placing files in `layouts/` mirroring the Docsy theme structure.
- Goldmark renderer is set to `unsafe = true` — raw HTML is allowed in markdown.

## Key Config Files

- `hugo.toml` — Main Hugo config (base URL, languages, theme params, taxonomy, markup settings, Docsy module import)
- `netlify.toml` — Netlify build commands, environment vars (Hugo 0.125.7, Go 1.22.2), and redirects
- `package.json` — npm scripts wrapping Hugo commands; pinned hugo-extended 0.125.7

## Requirements

Hugo Extended 0.110.0+, Node.js LTS, Go (for Hugo module resolution). The `prebuild` script handles git submodule sync automatically.
