#!/bin/bash
set -e

if [ -f ".env.local" ]; then
  source .env.local
else
  read -rp "GitHub Username: " GH_USER
  read -rsp "GitHub Token: " GH_TOKEN
  echo ""
  read -rp "Repository Name: " GH_REPO
fi

echo ""
echo "Пушим в $GH_USER/$GH_REPO..."

git add .
git config user.email "$GH_USER@users.noreply.github.com" 2>/dev/null || true
git config user.name "$GH_USER" 2>/dev/null || true

if git diff --cached --quiet; then
  echo "Нет изменений — force push..."
fi

git commit -m "update" 2>/dev/null || true
git branch -M main 2>/dev/null || true

REMOTE_URL="https://${GH_USER}:${GH_TOKEN}@github.com/${GH_USER}/${GH_REPO}.git"
git remote set-url origin "$REMOTE_URL" 2>/dev/null || git remote add origin "$REMOTE_URL"
git push -u origin main --force

git remote set-url origin "https://github.com/${GH_USER}/${GH_REPO}.git"
unset GH_TOKEN REMOTE_URL

echo ""
echo "✅ Push выполнен! Проверяю Actions..."
sleep 5
./check_actions.sh
