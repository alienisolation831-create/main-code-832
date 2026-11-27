# AI Brand Monitor

[English](#english) | [Русский](#russian)

<a id="english"></a>

## English

AI Brand Monitor is a self-hosted web application for tracking brand mentions in large language model responses. Configure your brand, competitors, geographic market, prompts and models. Results are stored in SQLite and can be exported to Excel.

### Requirements

- Your own account and API key for GPTunneL (ChatGPT, Gemini, DeepSeek, Qwen and GigaChat) and/or Yandex Cloud (Alice AI LLM).
- A Yandex Cloud folder ID when using Alice AI LLM.
- A unique password for accessing the application.
- Python 3.10+ or Docker with Docker Compose.

The application does not supply API keys or free access to models. Model availability and request prices depend on your account and current provider pricing. Arbitrary API providers are not guaranteed to work without code changes.

### Environment variables

| Variable | Purpose |
| --- | --- |
| `APP_PASSWORD` | Required. Application owner's password. |
| `GPTUNNEL_API_KEY` | API key for the five GPTunneL models. |
| `YANDEX_API_KEY` | API key for Alice AI LLM. |
| `YANDEX_FOLDER_ID` | Folder ID; required with the Yandex key. |
| `APP_SECRET_KEY` | Optional session secret. If empty, it is generated and stored in the data directory. |
| `MAX_REQUESTS_PER_RUN` | Logical requests per run; defaults to 100. This is not a monetary limit. |
| `SESSION_COOKIE_SECURE` | Set to `true` for HTTPS; use `false` only for local HTTP. |
| `TRUST_PROXY` | Set to `true` only behind a trusted, correctly configured reverse proxy. |
| `BRAND_MONITOR_DATA_DIR` | Persistent database directory; `/data` in Docker and on Amvera. |

Additional model and pricing options are listed in `.env.example`. If available models change, set the current model ID using the corresponding variable. Pre-run cost estimates are not displayed because costs depend on your pricing plan. Request costs are based on provider API data; Yandex estimates use configured rates or built-in approximate values.

### Deploy on Amvera

1. Create a Python project and upload the repository files, including `amvera.yaml` and `requirements.txt`.
2. In the environment variables/secrets settings, add `APP_PASSWORD`, `GPTUNNEL_API_KEY` and/or both `YANDEX_API_KEY` and `YANDEX_FOLDER_ID`.
3. Set `SESSION_COOKIE_SECURE=true` for HTTPS. Make sure persistent storage at `/data` is attached and the application port is 5000.
4. Start the build and open the application URL. Log in, create a project and select the configured models.

An Amvera configuration is included. Platform interface labels may change.

### Run with Docker (locally or on another server)

```sh
cp .env.example .env
# Set your own password and at least one set of API credentials in .env.
# Never commit .env.
docker compose up -d --build
```

Open http://localhost:5000 on the host machine. On a remote server, configure HTTPS through a reverse proxy; the Compose port is intentionally bound to loopback only. For public HTTPS, set `SESSION_COOKIE_SECURE=true`. Enable `TRUST_PROXY=true` only with a correctly configured trusted proxy. The `monitor_data` volume persists results across restarts.

### Run without Docker (macOS/Linux)

```sh
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
export APP_PASSWORD='replace-with-your-own-long-password'
export GPTUNNEL_API_KEY='replace-with-your-own-key'
# Alternatively, set YANDEX_API_KEY and YANDEX_FOLDER_ID.
python app.py
```

Open http://localhost:5000. For persistent hosting, use Gunicorn with one worker and multiple threads, as specified in the Dockerfile. The application is designed for a single instance and a single owner. Do not scale workers or replicas without redesigning the background jobs and database.

### Security and API costs

- Never publish real API keys, passwords, `.env`, SQLite databases or the data directory. The example configuration contains no secrets.
- Use HTTPS, a strong unique password and provider-side spending limits. Request-count limits do not guarantee fixed charges, especially when retries or internal API calls occur.
- Login attempts (five per minute per application instance), concurrent jobs and formulas in XLSX exports are restricted. These are baseline safeguards, not a guarantee of public-server security.
- The web interface is intended for the owner, not for providing unlimited access to paid APIs to other users.
- Before production deployment, review dependency versions, API compatibility and infrastructure settings. A full penetration test and live paid API requests have not been performed.

### Data and interpretation

The application starts with an empty project. Request history and credentials are not included in the source code. Web-search mode uses provider integrations; memory mode does not initiate a general web search. Metrics represent the selected API models' responses under specified conditions, not necessarily the exact behavior of their consumer-facing chat interfaces.

---

<a id="russian"></a>

## Русский

Веб-приложение для мониторинга упоминаний брендов в ответах языковых моделей. Настройте бренд, конкурентов, географию, запросы и модели; результаты сохраняются в SQLite и экспортируются в Excel.

## Что потребуется

- Собственный аккаунт и API-ключ GPTunneL (для ChatGPT, Gemini, DeepSeek, Qwen и GigaChat) и/или Yandex Cloud (для Alice AI LLM).
- Для Alice AI LLM также требуется ID каталога Yandex Cloud.
- Уникальный пароль для доступа к приложению.
- Python 3.10+ или Docker с Docker Compose.

Приложение не выдаёт ключи и не предоставляет бесплатный доступ к моделям. Доступность моделей и стоимость запросов зависят от вашего аккаунта и актуальных тарифов. Подключение произвольного API без адаптации кода не гарантируется.

## Переменные окружения

| Переменная | Назначение |
| --- | --- |
| `APP_PASSWORD` | Обязательно. Пароль владельца приложения. |
| `GPTUNNEL_API_KEY` | Для пяти моделей GPTunneL. |
| `YANDEX_API_KEY` | Для Alice AI LLM. |
| `YANDEX_FOLDER_ID` | ID каталога; обязателен вместе с ключом Yandex. |
| `APP_SECRET_KEY` | Необязательно. Секрет сессий; если пуст, генерируется и сохраняется в каталоге данных. |
| `MAX_REQUESTS_PER_RUN` | Лимит логических запросов за один запуск, по умолчанию 100. Не денежный лимит. |
| `SESSION_COOKIE_SECURE` | `true` для HTTPS, `false` только для локального HTTP. |
| `TRUST_PROXY` | `true` только за доверенным прокси с корректной обработкой заголовков. |
| `BRAND_MONITOR_DATA_DIR` | Постоянная директория базы данных; `/data` в контейнере и на Amvera. |

Дополнительные настройки моделей и тарифов перечислены в `.env.example`. При изменении доступных моделей задайте актуальный ID соответствующей переменной. Оценка затрат до запуска не показывается, поскольку зависит от вашего тарифа. Стоимость по итогам запроса зависит от данных API; оценка Yandex использует настройки ставок или встроенные ориентировочные значения.

## Развёртывание на Amvera

1. Создайте проект Python и загрузите файлы этого репозитория, включая `amvera.yaml` и `requirements.txt`.
2. В настройках переменных окружения/секретов добавьте `APP_PASSWORD`, `GPTUNNEL_API_KEY` и/или пару `YANDEX_API_KEY`, `YANDEX_FOLDER_ID`.
3. Для HTTPS установите `SESSION_COOKIE_SECURE=true`. Убедитесь, что постоянное хранилище `/data` подключено, а порт приложения 5000.
4. Запустите сборку и откройте URL приложения. Войдите по паролю, создайте проект и выберите подключённые модели.

Конфигурация Amvera входит в архив. Названия элементов интерфейса платформы могут изменяться.

## Запуск через Docker на другом сервере или локально

```sh
cp .env.example .env
# Заполните пароль и хотя бы один комплект API-ключей в .env
# Не коммитьте .env

docker compose up -d --build
```

Откройте http://localhost:5000 на машине запуска. На удалённом сервере настройте HTTPS через обратный прокси; порт в Compose намеренно доступен только на loopback. Для публичного HTTPS установите `SESSION_COOKIE_SECURE=true`. При корректно настроенном доверенном прокси включите `TRUST_PROXY=true`. Хранилище `monitor_data` сохраняет результаты между перезапусками.

## Запуск без Docker (macOS/Linux)

```sh
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
export APP_PASSWORD='replace-with-your-own-long-password'
export GPTUNNEL_API_KEY='replace-with-your-own-key'
# либо задайте YANDEX_API_KEY и YANDEX_FOLDER_ID
python app.py
```

Откройте http://localhost:5000. Для постоянного размещения используйте Gunicorn с одним worker и несколькими потоками, как в Dockerfile. Приложение рассчитано на один экземпляр и одного владельца; не масштабируйте workers/реплики без переработки фоновых задач и базы данных.

## Безопасность и расходы

- Не публикуйте настоящие ключи, пароль, `.env`, SQLite и каталог данных. Пример переменных не содержит секретов.
- Используйте HTTPS, сильный уникальный пароль и лимиты расходов в кабинете API-провайдера. Ограничение числа запросов не гарантирует фиксированного списания, особенно при повторных попытках и внутренних вызовах API.
- Ограничены попытки входа (5 за минуту на экземпляр приложения), одновременные задачи и формулы в XLSX. Это базовые меры, не гарантия безопасности публичного сервера.
- Веб-интерфейс предназначен для владельца, не для предоставления платного API неограниченному кругу пользователей.
- Перед production-развёртыванием проверьте версии зависимостей, актуальность API и настройки инфраструктуры. Полный пентест и живые платные запросы не выполнялись.

## Данные

Начальный проект пустой. История запросов и ключи не входят в исходники. Режим веб-поиска использует интеграции провайдеров; режим памяти не инициирует общий веб-поиск. Метрики отражают ответы выбранных API-моделей в заданных условиях, а не гарантированно точное поведение их потребительских чат-интерфейсов.
