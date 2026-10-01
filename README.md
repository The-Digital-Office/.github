# The Digital Office: organisation defaults

This repository holds the defaults and shared automation used by every
repository in [The-Digital-Office](https://github.com/The-Digital-Office).
The policy behind it is in [GOVERNANCE.md](GOVERNANCE.md).

## Contents

| Path | Purpose |
|---|---|
| [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md), [`CONTRIBUTING.md`](CONTRIBUTING.md), [`SECURITY.md`](SECURITY.md), [`SUPPORT.md`](SUPPORT.md) | Organisation-wide community health files. GitHub shows these in any repository that does not have its own. |
| [`.github/ISSUE_TEMPLATE/`](.github/ISSUE_TEMPLATE), [`.github/pull_request_template.md`](.github/pull_request_template.md) | Default issue forms and pull request template. |
| [`.github/workflows/repository-standards.yml`](.github/workflows/repository-standards.yml) | Shared workflow that checks required files and validates `publiccode.yml`. Called by every repository. |
| [`workflow-templates/`](workflow-templates) | Makes the standards workflow available under **Actions → New workflow** for existing repositories. |
| [`scripts/apply-baseline.sh`](scripts/apply-baseline.sh) | Applies branch rules, merge settings, security settings and labels to a repository. |
| [`profile/README.md`](profile/README.md) | The organisation's public profile page. |

## Using the shared workflow

New repositories created from
[`repository-template`](https://github.com/The-Digital-Office/repository-template)
already call it. To add it to an existing repository, create
`.github/workflows/standards.yml`:

```yaml
name: Repository standards
on:
  pull_request:
  push:
    branches: [main]
  workflow_dispatch:
permissions:
  contents: read
jobs:
  standards:
    uses: The-Digital-Office/.github/.github/workflows/repository-standards.yml@v1
```

## Releasing changes

Repositories call the workflow at the `v1` tag. After merging a change to the
workflow, move the tag:

```sh
git tag -f v1 && git push -f origin v1
```

Also create an immutable tag for the release (for example `v1.1.0`) and record
it in [CHANGELOG.md](CHANGELOG.md). Changes that could make passing
repositories fail are released as `v2`.

## Licence

Code in this repository is licensed under the [MIT licence](LICENSE).
Documentation is licensed under the
[Open Government Licence v3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).
