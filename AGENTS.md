# AGENTS.md

## Overview

This repo contains the source code for a personal website, built using the static site generator [MkDocs](https://www.mkdocs.org/) with the [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) theme. The website serves as a professional site for a research engineer.

## Key Files

- `mkdocs.yml`: The main configuration file for the MkDocs project. It defines the site's name, navigation structure, theme, and plugins.
- `docs/`: This directory contains the website's content in Markdown format.

## Dependencies

The project's dependencies are managed using `uv` and are listed in the `pyproject.toml` file. To install the dependencies, you first need to install `uv` on your system. You can find the installation instructions [here](https://github.com/astral-sh/uv). Once you have `uv` installed, you can sync dependencies with

```bash
uv sync
```

### Building and Running

To build and serve the website locally, one should install `uv`. Then simply,

```bash
uv run mkdocs build
```

or

```bash
uv run mkdocs serve
```

NOTE: You MUST use `uv run mkdocs ...` and NOT `mkdocs ...`!

The project is set up for continuous deployment using GitHub Pages, as configured in `.github/workflows/pages.yml`.

### Rebuilding CSS files

Execute the `css.sh` script to build CSS extras.

## Content Overview

- `docs/index.md`: The main landing page of the website. It contains a brief introduction to the author and the purpose of the site.

- `docs/background.md`: CV like content rendered as a timeline.
  - `docs/timeline.json`: Input data used to render the timeline as JSON.

- `docs/stylesheets/`: Contains extra CSS for styling.
