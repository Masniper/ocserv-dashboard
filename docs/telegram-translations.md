# Telegram strings and bot metadata

You can override bundled English/Persian text without rebuilding binaries.

## API service (HTML messages to customers)

- **Embedded defaults:** `services/api/internal/services/telegram/i18n/default.json`
- **Optional overlay:** set `TELEGRAM_I18N_PATH` to a JSON file with the same top-level keys (`en`, `fa`). Values you omit keep the embedded default. Restart the API after changes.

Keys include notification templates such as `pkg_*`, `awaiting_*`, `rejected_*`, `new_account`, `renewal`, `support_suffix`, and related fragments used by `telegram/controller.go`.

## Standalone Telegram bot (BotFather metadata)

- **Embedded defaults:** `services/telegram_bot/internal/bot/metadata_locales.json`
- **Optional overlay:** set `TELEGRAM_BOT_METADATA_LOCALES_PATH` to a JSON file with the same structure (`en` / `fa` objects with `commands`, `long_description`, `short_description`). Restart the bot after changes.

## Dashboard

The home dashboard shows a read-only snapshot of Telegram settings (`enabled`, whether a bot token is stored, optional `bot_username` from settings). It does not call the Telegram API.
