# Security policy

This policy applies to every repository in
[The-Digital-Office](https://github.com/The-Digital-Office) unless that
repository has its own `SECURITY.md`.

## Reporting a vulnerability

**Do not report security vulnerabilities in public issues, pull requests or
discussions.**

Report them privately using GitHub's private vulnerability reporting:

1. Go to the **Security** tab of the affected repository.
2. Select **Report a vulnerability**.
3. Describe the problem, how to reproduce it, and its likely impact.

Only the repository maintainers and organisation owners can see the report.

## What to expect

- We aim to acknowledge reports within **5 working days**.
- We will keep you informed while we investigate and fix the issue.
- We will agree a disclosure date with you, and credit you in the advisory
  unless you would prefer not to be named.

## Supported versions

Unless a repository states otherwise, only the latest version on the `main`
branch is supported with security fixes.

## Secrets committed by mistake

If you find a credential, token or other secret in one of our repositories,
report it as above. Maintainers must treat any committed secret as compromised
and revoke it, not just remove it from the code.
