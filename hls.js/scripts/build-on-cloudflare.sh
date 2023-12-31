#!/bin/bash
set -e

if [[ $(git rev-parse --is-shallow-repository) = "true" ]]; then
  # make sure everything is fetched
  git fetch --unshallow
fi

npm ci --force
./scripts/set-package-version.sh
npm run lint
npm run type-check
npm run build:ci
npm run docs
./scripts/build-cloudflare.sh
