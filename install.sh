#!/bin/bash
# ============================================================
# install.sh — Установка зависимостей в Termux
# ============================================================

set -e

echo ""
echo "╔══════════════════════════════════════╗"
echo "║   Установка зависимостей в Termux    ║"
echo "╚══════════════════════════════════════╝"
echo ""

echo "[1/6] Обновление пакетов..."
pkg update -y
pkg upgrade -y

echo ""
echo "[2/6] Установка Git..."
pkg install git -y

echo ""
echo "[3/6] Установка OpenJDK 21..."
pkg install openjdk-21 -y

echo ""
echo "[4/6] Установка вспомогательных утилит..."
pkg install wget -y
pkg install unzip -y
pkg install curl -y

echo ""
echo "[5/6] Проверка версий..."
echo "  Java:  $(java -version 2>&1 | head -1)"
echo "  Git:   $(git --version)"

echo ""
echo "[6/6] Настройка переменных окружения..."
if ! grep -q "JAVA_HOME" "$HOME/.bashrc" 2>/dev/null; then
  echo 'export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))' >> "$HOME/.bashrc"
  echo 'export PATH=$PATH:$JAVA_HOME/bin' >> "$HOME/.bashrc"
fi
source "$HOME/.bashrc" 2>/dev/null || true

echo ""
echo "✅ Все зависимости установлены!"
echo ""
echo "Следующий шаг: запустите  ./build.sh"
echo ""
