#!/bin/bash
# ============================================================
# build.sh — Сборка APK через Gradle в Termux
# ============================================================

set -e

echo ""
echo "╔══════════════════════════════════════╗"
echo "║          Сборка APK (Debug)          ║"
echo "╚══════════════════════════════════════╝"
echo ""

# Проверка наличия gradlew
if [ ! -f "./gradlew" ]; then
  echo "❌ Файл gradlew не найден."
  echo "   Убедитесь, что вы находитесь в корне Android-проекта."
  exit 1
fi

# Проверка Java
if ! command -v java &> /dev/null; then
  echo "❌ Java не установлена. Запустите ./install.sh"
  exit 1
fi

echo "[1/3] Выдача прав на gradlew..."
chmod +x gradlew

echo ""
echo "[2/3] Запуск сборки assembleDebug..."
echo "      (Это может занять несколько минут)"
echo ""

./gradlew assembleDebug --stacktrace 2>&1 | tee build.log

echo ""
echo "[3/3] Проверка результата..."

APK_PATH="app/build/outputs/apk/debug/app-debug.apk"

if [ -f "$APK_PATH" ]; then
  SIZE=$(du -h "$APK_PATH" | cut -f1)
  echo ""
  echo "╔══════════════════════════════════════════════════════╗"
  echo "║  ✅ APK успешно собран!                               ║"
  echo "╠══════════════════════════════════════════════════════╣"
  echo "║  Путь: $APK_PATH"
  echo "║  Размер: $SIZE"
  echo "╚══════════════════════════════════════════════════════╝"
  echo ""
  echo "Для установки на устройство:"
  echo "  adb install $APK_PATH"
  echo ""
  echo "Следующий шаг: запустите  ./push.sh  для загрузки на GitHub"
else
  echo ""
  echo "❌ APK не найден. Проверьте build.log для деталей ошибки."
  exit 1
fi
