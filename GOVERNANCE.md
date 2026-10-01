# Repository governance

This document sets out the baseline every repository in
[The-Digital-Office](https://github.com/The-Digital-Office) is expected to meet,
and how that baseline is provided and checked. It is written to keep the burden
on maintainers low: most of it is supplied or enforced automatically.

## Principles

- **Standards first.** We use established standards, such as
  [publiccode.yml](https://yml.publiccode.tools), as published. We do not create
  local variants.
- **Automation over guidance.** Where something can be generated, validated or
  enforced automatically, it is.
- **Proportionate.** Most repositories have one or two maintainers. Controls are
  sized for that.

## What applies where

| Requirement | Private repositories | Public repositories |
|---|---|---|
| README, LICENSE, CODEOWNERS, CHANGELOG in the repository | Required | Required |
| Security policy, contributing guide, code of conduct, support, issue and pull request templates | Provided organisation-wide | Provided organisation-wide |
| Repository standards checks | Required | Required |
| `publiccode.yml` | Not required | Required for software; not required for repositories with the `documentation` topic |
| Protected `main` branch (ruleset) | Not available on the GitHub Free plan; followed by convention | Required |
| Secret scanning with push protection, private vulnerability reporting | Not available on the GitHub Free plan | Required |
| Dependabot alerts and security updates | Required | Required |

## Where things live

| Thing | Location | Why |
|---|---|---|
| Security policy, contributing guide, code of conduct, support, issue and pull request templates | This repository (`The-Digital-Office/.github`) | GitHub uses these automatically for every repository that does not have its own. Changing them here changes them everywhere. |
| Repository standards checks | [`.github/workflows/repository-standards.yml`](.github/workflows/repository-standards.yml) in this repository, released as `@v1` | Each repository calls the shared workflow, so a fix or improvement here reaches every repository. |
| Per-repository files | [`repository-template`](https://github.com/The-Digital-Office/repository-template) | Files that must be specific to each repository, or that GitHub does not inherit (LICENSE, CODEOWNERS). |
| Branch rules, merge and security settings | [`scripts/apply-baseline.sh`](scripts/apply-baseline.sh) | Templates do not copy settings. An organisation owner runs the script once per repository. |

A repository may add its own version of any organisation-wide file when it has
a genuine need to differ. Its own file then replaces the organisation default.

## Licensing

- **Code** is licensed under the [MIT licence](https://opensource.org/license/mit).
- **Documentation and other content** is licensed under the
  [Open Government Licence v3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).
- The copyright holder is **The Digital Office for Scottish Local Government**.

A repository that contains only documentation or content should use the Open
Government Licence as its `LICENSE`.

## publiccode.yml

Public software repositories must include a valid
[publiccode.yml](https://yml.publiccode.tools) at the repository root. It is
validated on every pull request and push to `main` using the official
[publiccode-parser-action](https://github.com/italia/publiccode-parser-action).

- The template supplies Digital Office defaults (organisation, licence,
  maintenance type, audience, language). Maintainers complete the description,
  features, platforms, category and software type.
- Values still starting with `TODO` are reported as **warnings** until the
  repository's first release tag, then as **errors**.
- A public repository that is not software (guidance, standards, architecture
  documentation) should have the `documentation` topic. The check is then
  skipped.
- When a private repository is made public, the check starts applying
  automatically.

## Branch and pull request workflow

1. Work on a short-lived branch created from `main`.
2. Open a pull request into `main`.
3. The **Repository standards** checks must pass, on a branch that is up to
   date with `main`.
4. Squash-merge. The branch is deleted automatically.

**No approvals are required.** A repository with a single maintainer could
otherwise never merge, because GitHub does not let you approve your own pull
request. Where there are two maintainers, the other should review. Repository
admins can bypass the rules when merging a pull request in an emergency, but
cannot push directly to `main`.

## Setting up a new repository

1. Create the repository from
   [`repository-template`](https://github.com/The-Digital-Office/repository-template)
   (**Use this template** → **Create a new repository**).
2. Wait about a minute. The template's setup workflow fills in the repository
   name, URL, date and code owner, and opens an issue titled
   **Complete repository setup** with the remaining steps.
3. An organisation owner applies the settings:

   ```sh
   scripts/apply-baseline.sh <repository-name>
   ```

   On Windows, run it in Git Bash, which is installed with
   [Git for Windows](https://gitforwindows.org/). It needs the
   [GitHub CLI](https://cli.github.com/) (signed in with `gh auth login`) and
   [jq](https://jqlang.org/).

4. Work through the setup issue and close it.

## Changing the baseline

Changes to this repository go through a pull request like any other. Changes to
the shared workflow are released by moving the `v1` tag. A change that could
make previously passing repositories fail is released as `v2`, and repositories
move to it deliberately.
