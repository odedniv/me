# odedniv.me

This is the source code for [odedniv.me](https://odedniv.me), enjoy taking a look around.

**The Git history of all branches in this repository are updated _a lot_, so don't expect to be able to merge updates.**

This repository is also used for the [utteranc.es](https://utteranc.es) website comments.

## Repository Structure

As mentioned above, the Git history is constantly updating.
This branch is then rebuilt from a set of branches.

This section describes the remotes and branches used for this repository.

### Remotes

* origin: github.com/odedniv/me - main source.
* template-upstream: github.com/danielcgilibert/blog-template - template.
* template: github.com/odedniv/blog-template - template-upstream fork.

### Branches

* base (origin/base) - branch infra tools (and this documentation).
  * main (origin/main) - final site, generated and updated with `./merge.sh`.
* me (origin/me) - personal content.
* template-upstream/main - no local branch.
  * template/me - personal changes to the template.
  * template/... - publicly relevant fixes to the template, pull-requested.
  * template/main - all publicly relevant fixes merged together, does not include template/me.
