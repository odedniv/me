#!/bin/bash

set -ex

pnpm build
aws s3 cp dist/ s3://odedniv.me/ --recursive
