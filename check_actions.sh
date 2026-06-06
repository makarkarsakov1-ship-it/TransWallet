#!/bin/bash

if [ -f ".env.local" ]; then
  source .env.local
else
  read -rp "GitHub Username: " GH_USER
  read -rsp "GitHub Token: " GH_TOKEN
  echo ""
  read -rp "Repository Name: " GH_REPO
fi

echo "Получаю статус GitHub Actions..."

RUN_ID=$(curl -s \
  -H "Authorization: token $GH_TOKEN" \
  "https://api.github.com/repos/$GH_USER/$GH_REPO/actions/runs?per_page=1" \
  | grep '"id"' | head -1 | grep -o '[0-9]*')

STATUS=$(curl -s \
  -H "Authorization: token $GH_TOKEN" \
  "https://api.github.com/repos/$GH_USER/$GH_REPO/actions/runs/$RUN_ID" \
  | grep -E '"status"|"conclusion"' | head -2)

echo "$STATUS"

JOB_ID=$(curl -s \
  -H "Authorization: token $GH_TOKEN" \
  "https://api.github.com/repos/$GH_USER/$GH_REPO/actions/runs/$RUN_ID/jobs" \
  | grep '"id"' | head -1 | grep -o '[0-9]*')

echo ""
echo "Логи ошибок:"
curl -sL \
  -H "Authorization: token $GH_TOKEN" \
  "https://api.github.com/repos/$GH_USER/$GH_REPO/actions/jobs/$JOB_ID/logs" \
  | grep -i "error\|ошибка\|FAILED\|What went wrong\|Exception" | head -30

unset GH_TOKEN
