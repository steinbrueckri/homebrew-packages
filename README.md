# homebrew-packages

My personal homebrew tap (package repository for the homebrew package manager). <https://brew.sh>

## How to use

You only need to add this repo to your brew installation via the
`brew tap` command, like this `brew tap steinbrueckri/packages`.

## Updating formulae

Formula versions are kept up to date with `scripts/update.py`, which reads the
GitHub repo and current tag from each formula, looks up the latest release via
the `gh` CLI, and rewrites the `url`, `sha256` and `version` fields. Formulae
without a GitHub release URL (head-only or commit-pinned builds) are skipped.

```sh
just check            # report which formulae have a newer release
just update           # update all formulae
just update ringo     # update a single formula
```

The same script runs in CI: the `Update formulae` GitHub Action checks weekly
(and on manual dispatch) and opens a pull request when something is out of date.

Requires the [`gh`](https://cli.github.com/) CLI to be installed and
authenticated.

## Test and CI

At the moment nothing :D

## TODOs

- [ ] CI and tests?
- [x] Something to update versions?
