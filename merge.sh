#!/bin/bash

set -ex

git checkout origin/base
git checkout -B main
git merge template/main --allow-unrelated-histories --no-edit
git merge template/me --no-edit
git merge origin/me --allow-unrelated-histories --strategy-option theirs --no-edit
