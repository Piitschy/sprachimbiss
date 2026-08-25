---
name: sprachimbiss-repo
description: Use when working on the Sprachimbiss repository, especially Astro pages, Bun commands, Docker images, just deploy, releases, or GHCR publishing.
---

# Sprachimbiss Repository

Use this skill for changes to the Sprachimbiss project. Work from the repository root.

## Project Structure

- `src/pages/` contains Astro routes. `src/pages/index.astro` is the homepage and `src/pages/impressum.astro` is the legal notice.
- `src/layouts/` contains shared page layouts.
- `src/components/` contains reusable Astro components.
- `src/assets/` contains imported source assets.
- `public/` contains files copied unchanged to the generated site.
- `dist/` is Astro's generated static output.
- `Dockerfile` builds the site and serves `dist/` with Nginx.
- `nginx.conf` configures the production server on port `4321`.

## Development

- Use Bun for dependency management and scripts. Keep `bun.lock` and `bun.lockb` consistent with dependency changes.
- Install dependencies with `bun install`.
- Start local development with `bun run dev` or `just dev-local`.
- Build the static site with `bun run build` or `just build-local`.
- Preview a production build with `bun run preview`.
- The Astro site is static. Do not introduce a server runtime without an explicit requirement.

## Container Workflow

- Build locally with `just build` or `docker build -t ghcr.io/piitschy/sprachimbiss:<tag> .`.
- Run the container with `just run` or `docker run -p 4321:4321 --rm <image>`.
- The production image is `ghcr.io/piitschy/sprachimbiss`.
- GitHub Actions builds and pushes an image when a tag matching `vX.Y.Z` is pushed. The image tag omits the leading `v`, for example `v1.2.3` becomes `ghcr.io/piitschy/sprachimbiss:1.2.3`.
- After a successful image push, the workflow calls the repository variable `PORTAINERWEBHOOK` with `?VERSION=X.Y.Z` to trigger the Portainer deployment.

## Releases

- Use `just deploy` for a release. It increments the patch version in `package.json`, creates a release commit, creates the annotated `vX.Y.Z` tag, and pushes the current commit and tag to `origin`.
- `just deploy` is implemented in `scripts/release.mjs` and uses Node.js rather than Bash, so it works from Windows, macOS, and Linux.
- `package.json` must not have uncommitted changes before running `just deploy`.
- The release tag starts the `.github/workflows/publish-image.yml` workflow. Do not manually push the versioned image as part of the normal release flow.
- Do not run `just deploy` during implementation or tests unless the user explicitly requests a release; it changes Git history and pushes to the remote.

## Change and Verification Rules

- Preserve the existing Astro and Nginx structure unless the task requires otherwise.
- Prefer minimal changes and ASCII text in configuration and scripts.
- Every completed feature must be committed automatically after verification, unless the user explicitly asks not to commit.
- Before committing, inspect `git status`, `git diff`, and `git diff --check`; stage only files belonging to the feature and use a concise commit message.
- Never include unrelated user changes or secrets in an automatic feature commit.
- After application changes, run `bun run build` when dependencies and the local environment are available.
- For release-script changes, run `node --check scripts/release.mjs` and `just --dry-run deploy`.
- Run `git diff --check` before finishing.
