# Changelog

All notable changes to this repository are recorded here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Changed

- `apply-baseline.sh` dry runs now say what would be applied, and the
  `documentation` topic reminder is no longer shown for `.github` or template
  repositories.

### Added

- `.gitattributes` so shell scripts always check out with LF line endings,
  which lets them run in Git Bash on Windows.

## [1.0.0] - 2026-10-01

### Added

- Organisation-wide code of conduct, contributing guide, security policy and support page.
- Issue forms (bug report, change request) and pull request template.
- Shared `repository-standards.yml` workflow: required files check and publiccode.yml validation.
- Starter workflow for adding the standards checks to existing repositories.
- `scripts/apply-baseline.sh` to apply branch rules, merge, security and label settings.
- Repository governance policy (`GOVERNANCE.md`) and organisation profile.
