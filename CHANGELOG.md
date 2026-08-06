# Changelog

All notable changes to GoldScalper are documented here.

## [0.7.0-alpha] - 2026-08-06

### Added

- Execution-free trade-plan data type
- ATR-based dynamic stop loss and risk-reward take profit planning
- Live bid/ask entry calculation by signal direction
- Broker stop-distance and risk-based volume validation

### Safety

- A plan is rejected when price, volume, broker constraints, or inputs are invalid.
- Trade execution remains disabled pending execution-layer review.

## [0.6.0-alpha] - 2026-08-06

### Added

- Deterministic confluence scoring from trend, confirmed structure, and ATR availability
- Directional signal score data type
- Configurable minimum-confidence qualification gate
- Default 75-confidence threshold; full trend/structure confluence scores 85

### Safety

- Incomplete or conflicting analysis produces no tradable signal.
- Trade execution remains disabled while execution and exit modules are under development.

## [0.5.0-alpha] - 2026-08-06

### Added

- Confirmed swing-high and swing-low detection with configurable strength
- Closed-bar series retrieval for price-action analysis
- Basic Smart Money Concepts break-of-structure classification
- Configurable structure lookback and swing-strength inputs

### Safety

- Structure analysis uses completed candles only.
- Trade execution remains disabled while entry and exit engines are under development.

## [0.4.0-alpha] - 2026-08-06

### Added

- Closed-bar market-data access for a configurable signal timeframe
- EMA and ATR indicator-handle lifecycle management
- EMA-based bullish, bearish, neutral, and unknown trend classification
- Configurable fast EMA, slow EMA, ATR, and signal-timeframe inputs

### Safety

- Analysis is based on closed candles only; incomplete current-bar values are not used.
- Trade execution remains disabled while strategy and exit modules are under development.

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
