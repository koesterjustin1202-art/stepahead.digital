#!/bin/bash
# StepAhead Website Deploy Script
# Usage: ./deploy.sh

set -e

WEBSITE_DIR="$(cd "$(dirname "$0")" && pwd)"
TIMESTAMP=$(date -u '+%Y-%m-%d %H:%M:%S UTC')

echo "=== StepAhead Website Deploy ==="
echo "Timestamp: $TIMESTAMP"
echo ""

# Build with Hugo (minified)
echo "Building Hugo site..."
cd "$WEBSITE_DIR"
hugo --minify

if [ ! -d "public" ]; then
    echo "ERROR: public/ directory not found after build"
    exit 1
fi

echo "Build complete."

# Git operations
cd "$WEBSITE_DIR"

# Check if this is a git repo
if [ ! -d ".git" ]; then
    echo "ERROR: Not a git repository. Run 'git init' first."
    exit 1
fi

# Check if remote exists
REMOTE=$(git remote -v 2>/dev/null | head -1)
if [ -z "$REMOTE" ]; then
    echo ""
    echo "WARNING: No remote configured."
    echo "To set up GitHub Pages deployment:"
    echo "  1. Create a repository on GitHub (e.g., stepahead-digital/stepahead.digital)"
    echo "  2. Add the remote: git remote add origin https://github.com/ACCOUNT/REPO.git"
    echo "  3. Run this script again."
    echo ""
    echo "For GitHub Pages with custom domain stepahead.digital:"
    echo "  - Set CNAME record to YOUR-GITHUB-USERNAME.github.io"
    echo "  - Enable GitHub Pages in repository settings"
    echo "  - Point to 'gh-pages' branch or use Actions"
    exit 0
fi

# Commit
echo "Committing build..."
git add -A
git commit -m "Deploy: $TIMESTAMP" --allow-empty

# Push
echo "Pushing to remote..."
git push origin HEAD:main

echo ""
echo "=== Deploy complete ==="
echo "Timestamp: $TIMESTAMP"