# Branches

This page describes the remotes and branches used around github.com/odedniv/me (odedniv.me).

## Remotes

* origin: github.com/odedniv/me - PRIVATE, main source.
* template-upstream: github.com/danielcgilibert/blog-template - PUBLIC, template.
* template: github.com/odedniv/blog-template - PUBLIC, template-upstream fork.

## Branches

* base (origin/base) - PRIVATE, branch infra tools (and this documentation).
  * main (origin/main) - PRIVATE, final site, generated and updated with `./merge.sh`.
* me (origin/me) - PRIVATE, personal content.
* template-upstream/main - PUBLIC, no local branch.
  * template/me - PUBLIC, personal changes to the template.
  * template/... - PUBLIC, publicly relevant fixes to the template, pull-requested.
  * template/main - PUBLIC, all publicly relevant fixes merged together, does not include template/me.
