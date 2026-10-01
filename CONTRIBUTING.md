# Contributing

Thank you for helping improve a Digital Office project. This guide applies to
every repository in [The-Digital-Office](https://github.com/The-Digital-Office)
unless that repository has its own `CONTRIBUTING.md`.

## Before you start

- **Small fixes** (typos, broken links, obvious bugs): open a pull request.
- **Anything larger**: open an issue first so we can agree the approach before
  you spend time on it.
- **Security problems**: do not open an issue. Follow [SECURITY.md](SECURITY.md).

## How we work

Our repositories usually have one or two maintainers, so the workflow is kept
deliberately light:

1. Create a branch from `main` with a short descriptive name, for example
   `fix-date-parsing` or `add-export-csv`.
2. Make your changes in small, focused commits.
3. Update `CHANGELOG.md` under **Unreleased** if the change is visible to users.
4. Open a pull request into `main` and complete the pull request template.
5. Wait for the **Repository standards** checks (and any project checks) to pass.
6. A maintainer reviews and squash-merges. The branch is deleted automatically.

`main` is protected: changes reach it only through a pull request with passing
checks. Force-pushes and branch deletion are blocked.

## Peer review

Where a repository has two maintainers, the other maintainer should review.
Where there is only one, the maintainer may merge their own pull request once
checks pass, but should use the pull request description to record what was
changed and why, so the history stays understandable to whoever comes next.

## Commit and pull request style

- Write in plain English. Say what changed and why.
- Link the issue the pull request resolves, for example `Closes #12`.
- Never commit secrets, credentials, personal data or production data.

## Licensing of contributions

By contributing you agree that your contribution is licensed under the
licence(s) of the repository you are contributing to. Unless a repository says
otherwise, code is licensed under the [MIT licence](https://opensource.org/license/mit)
and documentation under the
[Open Government Licence v3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).

## Code of conduct

Everyone taking part is expected to follow our [code of conduct](CODE_OF_CONDUCT.md).
