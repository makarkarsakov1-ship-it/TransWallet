# 🚌 Транспортная карта — Transit App

Демо-приложение для управления транспортной картой с поддержкой NFC, историей поездок и пополнением баланса.

---

## 📱 Быстрый просмотр (HTML)

Просто откройте `index.html` в браузере — всё работает без сборки.

---

## 🛠️ Установка в Termux

### 1. Установка зависимостей

```bash
# Скопируйте проект в Termux, затем:
chmod +x install.sh
./install.sh
```

Скрипт автоматически установит:
- `git`
- `openjdk-21`
- `wget`, `unzip`, `curl`

---

## 🏗️ Сборка APK

```bash
chmod +x build.sh
./build.sh
```

После успешной сборки APK будет по пути:
```
app/build/outputs/apk/debug/app-debug.apk
```

---

## 🚀 Push на GitHub

```bash
chmod +x push.sh
./push.sh
```

Скрипт спросит:
```
GitHub Username:   ваш_логин
GitHub Token:      ваш_PAT_токен  (скрыто, не отображается)
Repository Name:   transport-app
```

### Как получить Personal Access Token (PAT):
1. Откройте: https://github.com/settings/tokens/new
2. Выберите срок действия
3. Отметьте права: `repo` (полный доступ)
4. Нажмите **Generate token**
5. Скопируйте токен — он показывается **один раз**

> ⚠️ Токен **не сохраняется** в файлах проекта и **не коммитится**.

После push скрипт выполнит автоматически:
- `git init`
- `git add .`
- `git commit`
- создание ветки `main`
- подключение `remote origin`
- `git push`

---

## ⚙️ GitHub Actions (автоматическая сборка)

После каждого push в ветку `main` автоматически запускается workflow:

| Шаг | Действие |
|-----|----------|
| 1 | Checkout исходников |
| 2 | Установка JDK 21 |
| 3 | Кэширование Gradle |
| 4 | `./gradlew lint` |
| 5 | `./gradlew assembleDebug` |
| 6 | Публикация APK как Artifact |

### Где скачать APK из GitHub Actions:
1. Откройте ваш репозиторий на GitHub
2. Перейдите во вкладку **Actions**
3. Нажмите на последний workflow run
4. Прокрутите вниз до раздела **Artifacts**
5. Скачайте **app-debug**

---

## 📁 Структура проекта

```
transport-app/
├── index.html                    # Готовое HTML-приложение
├── install.sh                    # Установка зависимостей Termux
├── build.sh                      # Сборка APK
├── push.sh                       # Push на GitHub
├── README.md                     # Эта инструкция
├── .gitignore                    # Создаётся при первом push
└── .github/
    └── workflows/
        └── build.yml             # GitHub Actions workflow
```

---

## 🔧 Команды вручную (если нужно)

```bash
# Установка Termux-пакетов вручную
pkg update -y && pkg upgrade -y
pkg install git openjdk-21 wget unzip curl -y

# Сборка APK вручную
chmod +x gradlew
./gradlew assembleDebug

# Git вручную
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://TOKEN@github.com/USER/REPO.git
git push -u origin main
```

---

## 🎨 Функции приложения

- **Главный экран** — карта с балансом, последние поездки
- **История поездок** — фильтрация по типу транспорта
- **Пополнение баланса** — СБП и банковская карта (демо)
- **NFC оплата** — симуляция Tap to Pay
- **Настройки** — тёмная/светлая тема, уведомления

---

*Версия 1.0.0 (демо) — платежи не настоящие*
