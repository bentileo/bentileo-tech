# bentileo.tech

Personal site and project write-ups for Leonardo Bentivoglio, built with Astro
and served as static files from a VPS.

**Live at [bentileo.tech](https://bentileo.tech)**

## Structure

```
src/
    components/       BaseHead, Nav, Footer, EcgStrip, ProjectCard
    content/
        projects/     one Markdown file per project write-up
    layouts/          the shared page shell
    pages/            routes; projects/[...slug] renders each write-up
    styles/           design tokens and base styles
    consts.ts         site title, description, social links
    content.config.ts frontmatter schema for project entries
scripts/
    deploy.sh         build and rsync to the server
```

## Adding a project

Create a Markdown file in `src/content/projects/`. The frontmatter is validated
at build time, so a missing or misspelled field fails the build rather than
producing a broken page.

```yaml
---
title: 'Project name'
summary: 'One sentence, used on cards and as the page description.'
detail: 'Longer version, shown on the projects index only.'
status: 'live'          # live | building | planned
statusLabel: 'v1 live at example.com'
order: 3                # lower numbers appear first
stack: 'Python · SQL'
repo: 'https://github.com/...'
demo: 'https://...'
---
```

The body is Markdown. Inline HTML is allowed, and three helper classes are
styled: `.note` for a highlighted callout, `.q` for a pull quote, and `.flow`
for a monospace pipeline diagram.

## Development

```bash
make install
make dev        # http://localhost:4321
```

## Deployment

The server holds only built HTML, CSS, and JavaScript. Node is not installed
there.

```bash
make deploy     # builds locally, then rsyncs dist/ to the VPS
```

nginx serves `/var/www/bentileo.tech` at the apex domain. The ECG application
runs separately at `ecg.bentileo.tech` as its own service.

## Design notes

The palette follows ECG graph paper: warm white, a faint salmon grid, and the
clinical red used on printed rhythm strips. The waveform on the homepage is
generated from real P-QRS-T morphology rather than being decorative, and it
respects `prefers-reduced-motion`.

The email address is assembled by JavaScript at runtime, so it does not appear
in the served HTML.
