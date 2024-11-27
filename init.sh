#!/bin/bash

# Initialize git repository
git init

# Add all files
git add .

# Initial commit
git commit -m "Initial commit: 大道至简 blog setup"

# Rename master branch to main
git branch -M main

# Add remote for eggcaker.github.io
git remote add origin https://github.com/eggcaker/eggcaker.github.io.git

echo "Repository initialized!"
echo "Now run:"
echo "git push -u origin main"
echo ""
echo "Then visit https://github.com/eggcaker/eggcaker.github.io/settings/pages"
echo "to enable GitHub Pages with GitHub Actions as the source." 