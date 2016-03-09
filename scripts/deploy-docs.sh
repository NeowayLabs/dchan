#!/bin/bash

# Build script based on https://gist.github.com/domenic/ec8b0fc8ab45f39403dd

set -e

if [ "${TRAVIS_PULL_REQUEST}" != "false" ]; then
    exit 0
fi

if [ "${TRAVIS_BRANCH}" != "master" ]; then
    exit 0
fi

# clear and re-create the out directory
rm -rf out || exit 0;
mkdir out;

make dchan.pdf
make dchan.html
make dchan.txt

cp dchan.pdf dchan.html dchan.txt out
cp -R images out

# go to the out directory and create a *new* Git repo
cd out

mv dchan.html index.html
git init

# inside this git repo we'll pretend to be a new user
git config user.name "Travis CI"
git config user.email "tiago4orion@gmail.com"

git add .
git commit -m "Deploy to GitHub Pages"

# Force push from the current repo's master branch to the remote
# repo's gh-pages branch. (All previous history on the gh-pages branch
# will be lost, since we are overwriting it.) We redirect any output to
# /dev/null to hide any sensitive credential data that might otherwise be exposed.
git push --force --quiet "https://${GH_TOKEN}@${GH_REF}" master:gh-pages > /dev/null 2>&1
