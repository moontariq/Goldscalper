# Changelog

All notable changes to GoldScalper are documented here.

## [0.3.0-alpha] - 2026-08-06

### Added

- Broker environment guard for terminal connectivity and trading permissions
- Broker stop-distance validation helper
- Daily realized-loss circuit breaker scoped to the EA symbol and magic number
- Configurable maximum daily loss and open-position limit
- Position-capacity manager

### Safety

- All v0.2 market and session gates remain active.
- Trade execution remains disabled while strategy and exit modules are under development.

## [0.2.0-alpha] - 2026-08-06

### Added

- Market tradability validation during initialization
- Maximum-spread gate before strategy execution
- Configurable server-time trading session filter
- Risk-based position-sizing module

### Safety

- Trade execution remains disabled while strategy and exit modules are under development.

## [0.1.0-alpha] - 2026-08-06

### Added

- Initial MQL5 EA structure
- Configuration validation
- Domain enums, constants, and structured logging
- Repository documentation and MetaTrader build ignore rules
