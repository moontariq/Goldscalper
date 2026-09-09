# Changelog

All notable changes to GoldScalper are documented here.

## [0.11.0-alpha] - 2026-09-09

### Added

- MT5 real-tick backtesting protocol
- Execution-safety review checklist
- Optimization-run log template

### Safety

- v0.11 remains dry-run only; no live-execution feature is enabled.

## [0.10.0-alpha] - 2026-09-09

### Added

- Daily realized statistics for the EA symbol and magic number
- Local structured event records for qualified plans and exit recommendations

### Safety

- Events are terminal logs only; they do not send notifications or alter trading state.

## [0.9.0-alpha] - 2026-09-09

- Added an optional on-chart status dashboard; informational only.

## [0.8.0-alpha] - 2026-09-09

- Added read-only position snapshots and break-even / ATR-trailing recommendations; no position changes.

## [0.7.0-alpha] - 2026-09-09

- Added closed-candle dry-run trade planning and structured plan logging; no order requests.

## [0.6.0-alpha] - 2026-08-06

- Added deterministic confluence scoring and minimum-confidence qualification.

## [0.5.0-alpha] - 2026-08-06

- Added confirmed swing analysis and basic break-of-structure classification.

## [0.4.0-alpha] - 2026-08-06

- Added closed-bar market data, EMA/ATR handling, and trend classification.

## [0.3.0-alpha] - 2026-08-06

- Added daily-loss, broker, and position-capacity safety controls.

## [0.2.0-alpha] - 2026-08-06

- Added symbol, session, and spread safety gates.

## [0.1.0-alpha] - 2026-08-06

- Added initial MQL5 project foundation, configuration, logging, and documentation.
