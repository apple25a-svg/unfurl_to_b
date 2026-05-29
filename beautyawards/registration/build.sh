#!/bin/bash
set -e

ENV=${1:-test}

if [ "$ENV" != "test" ] && [ "$ENV" != "prod" ]; then
  echo "用法: ./build.sh [test|prod]"
  exit 1
fi

TARGET="dist/beautyawards/registration"

rm -rf dist
mkdir -p "$TARGET"
rsync -a \
  --exclude='.git' \
  --exclude='dist' \
  --exclude='build.sh' \
  --exclude='.gitignore' \
  --exclude='.DS_Store' \
  . "$TARGET/"

if [ "$ENV" = "prod" ]; then
  find "$TARGET" -name "*.html" | while read f; do
    sed -i '' \
      -e 's|tvbs-testing\.com\.tw|tvbs.com.tw|g' \
      -e 's|noindex,nofollow|index,follow|g' \
      "$f"
  done
  echo "✓ dist/ 已產生（正式站：tvbs.com.tw，index,follow）"
else
  echo "✓ dist/ 已產生（測試站：tvbs-testing.com.tw，noindex,nofollow）"
fi
