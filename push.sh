#!/bin/bash
# ============================================================
# push.sh — Публикация проекта на GitHub
# Токен НЕ сохраняется в файлах и НЕ коммитится
# ============================================================

set -e

echo ""
echo "╔══════════════════════════════════════╗"
echo "║        Публикация на GitHub          ║"
echo "╚══════════════════════════════════════╝"
echo ""

# ── Ввод данных ──────────────────────────────────────────────

read -rp "GitHub Username: " GH_USER
if [ -z "$GH_USER" ]; then
  echo "❌ Имя пользователя не может быть пустым."
  exit 1
fi

# Токен вводится скрыто (не отображается в терминале)
read -rsp "GitHub Token: " GH_TOKEN
echo ""
if [ -z "$GH_TOKEN" ]; then
  echo "❌ Токен не может быть пустым."
  exit 1
fi

read -rp "Repository Name: " REPO_NAME
if [ -z "$REPO_NAME" ]; then
  echo "❌ Название репозитория не может быть пустым."
  exit 1
fi

echo ""
echo "──────────────────────────────────────"
echo " Пользователь : $GH_USER"
echo " Репозиторий  : $REPO_NAME"
echo "──────────────────────────────────────"
echo ""

# ── Создание репозитория на GitHub через API ─────────────────

echo "[1/7] Создание репозитория на GitHub..."

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
  -X POST \
  -H "Authorization: token $GH_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/user/repos \
  -d "{\"name\":\"$REPO_NAME\",\"private\":false,\"auto_init\":false}")

if [ "$HTTP_STATUS" = "201" ]; then
  echo "   ✅ Репозиторий создан: https://github.com/$GH_USER/$REPO_NAME"
elif [ "$HTTP_STATUS" = "422" ]; then
  echo "   ℹ️  Репозиторий уже существует — продолжаем."
else
  echo "   ⚠️  Предупреждение: статус HTTP=$HTTP_STATUS (возможно, репозиторий уже есть)"
fi

# ── Git init ─────────────────────────────────────────────────

echo ""
echo "[2/7] Инициализация Git..."

if [ ! -d ".git" ]; then
  git init
  echo "   ✅ git init выполнен"
else
  echo "   ℹ️  Git уже инициализирован"
fi

# ── .gitignore ───────────────────────────────────────────────

echo ""
echo "[3/7] Создание .gitignore..."

cat > .gitignore << 'GITIGNORE'
# Android
*.apk
*.aab
*.ap_
*.dex
*.class
local.properties
.gradle/
build/
captures/
.externalNativeBuild/
.cxx/
*.jks
*.keystore
*.p12

# IDE
.idea/
*.iml
.DS_Store
Thumbs.db

# Secrets — НИКОГДА не коммитить!
*.env
.env*
secrets.properties
keystore.properties

# Logs
*.log
build.log
GITIGNORE

echo "   ✅ .gitignore создан"

# ── Git add & commit ─────────────────────────────────────────

echo ""
echo "[4/7] Добавление файлов..."
git add .
echo "   ✅ git add ."

echo ""
echo "[5/7] Создание коммита..."

git config user.email "$GH_USER@users.noreply.github.com" 2>/dev/null || true
git config user.name "$GH_USER" 2>/dev/null || true

if git diff --cached --quiet; then
  echo "   ℹ️  Нет изменений для коммита"
else
  git commit -m "🚀 Initial commit: Transport App

- HTML5 transit card app
- NFC payment simulation
- Trip history
- Balance top-up
- Settings with theme toggle
- Dark / Light theme support"
  echo "   ✅ Коммит создан"
fi

# ── Branch main ──────────────────────────────────────────────

echo ""
echo "[6/7] Настройка ветки main..."

CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "")
if [ "$CURRENT_BRANCH" != "main" ]; then
  git checkout -b main 2>/dev/null || git checkout main
fi
echo "   ✅ Ветка: main"

# ── Remote & Push ────────────────────────────────────────────

echo ""
echo "[7/7] Push на GitHub..."

REMOTE_URL="https://${GH_USER}:${GH_TOKEN}@github.com/${GH_USER}/${REPO_NAME}.git"

if git remote | grep -q "^origin$"; then
  git remote set-url origin "$REMOTE_URL"
else
  git remote add origin "$REMOTE_URL"
fi

git push -u origin main --force

# Удаляем токен из remote URL после push (безопасность)
git remote set-url origin "https://github.com/${GH_USER}/${REPO_NAME}.git"

# Очистка переменных с токеном
unset GH_TOKEN
unset REMOTE_URL

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║  ✅ Push успешно выполнен!                                ║"
echo "╠══════════════════════════════════════════════════════════╣"
echo "║  Репозиторий : https://github.com/$GH_USER/$REPO_NAME"
echo "║"
echo "║  GitHub Actions запустится автоматически."
echo "║  APK будет доступен в:"
echo "║  Actions → последний workflow → Artifacts → app-debug"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
