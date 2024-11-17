#!/bin/bash

set -ex

git checkout origin/base
git checkout -B main
git merge template/main --strategy-option ours --allow-unrelated-histories --no-edit
git merge template/me --strategy-option theirs --no-edit
git merge origin/me --strategy-option theirs --allow-unrelated-histories --no-edit
