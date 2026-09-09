# Changelog

All notable changes to GoldScalper are documented here.

## [0.9.0-alpha] - 2026-09-09

### Added

- Optional compact on-chart status dashboard
- EA state, trend, structure, confidence, position-presence, and plan-status visibility
- Dashboard cleanup on EA deinitialization

### Safety

- Dashboard updates use closed signal candles only.
- Dashboard rendering is informational and cannot open, modify, or close trades.

## [0.8.0-alpha] - 2026-09-09

### Added

- Read-only position snapshots scoped to the EA symbol and magic number
- Break-even trigger calculation from the position's initial risk
- ATR-based trailing-stop recommendation after break-even qualification
- Structured `EXIT DRY RUN` logging of suggested stop-loss adjustments

### Safety

- The EA does not modify, close, or open any position.
- Exit recommendations are calculated only once per newly closed signal candle.
- A trailing suggestion is accepted only when it improves the break-even stop level.

## [0.7.0-alpha] - 2026-09-09

### Added

- Execution-free trade-plan data type
- ATR-based dynamic stop loss and risk-reward take profit planning
- Live bid/ask entry calculation by signal direction
- Broker stop-distance and risk-based volume validation
- Closed-bar gate to evaluate at most one plan per completed signal candle
- Optional structured `DRY RUN` plan logging for manual terminal review

### Safety

- A plan is rejected when price, volume, broker constraints, or inputs are invalid.
- No MQL5 trade-request API is called; trade execution is disabled.

## [0.6.0-alpha] - 2026-09-09

### Added

- Deterministic confluence scoring from trend, confirmed structure, and ATR availability
- Directional signal score data type
- Configurable minimum-confidence qualification gate
- Default 75-confidence threshold; full trend/structure confluence scores 85

### Safety

- Incomplete or conflicting analysis produces no tradable signal.
- Trade execution remains disabled while execution and exit modules are under development.

## [0.5.0-alpha] - 2026-09-09

### Added

- Confirmed swing-high and swing-low detection with configurable strength
- Closed-bar series retrieval for price-action analysis
- Basic Smart Money Concepts break-of-structure classification
- Configurable structure lookback and swing-strength inputs

### Safety

- Structure analysis uses completed candles only.
- Trade execution remains disabled while entry and exit modules are under development.

## [0.4.0-alpha] - 2026-09-09

### Added

- Closed-bar market-data access for a configurable signal timeframe
- EMA and ATR indicator-handle lifecycle management
- EMA-based bullish, bearish, neutral, and unknown trend classification
- Configurable fast EMA, slow EMA, ATR, and signal-timeframe inputs

### Safety

- Analysis is based on closed candles only; incomplete current-bar values are not used.
- Trade execution remains disabled while strategy and exit modules are under development.

## [0.3.0-alpha] - 2026-09-09

### Added

- Broker environment guard for terminal connectivity and trading permissions
- Broker stop-distance validation helper
- Daily realized-loss circuit breaker scoped to the EA symbol and magic number
- Configurable maximum daily loss and open-position limit
- Position-capacity manager

### Safety

- All v0.2 market and session gates remain active.
- Trade execution remains disabled while strategy and exit modules are under development.

## [0.2.0-alpha] - 2026-09-09

### Added

- Market tradability validation during initialization
- Maximum-spread gate before strategy execution
- Configurable server-time trading session filter
- Risk-based position-sizing module

### Safety

- Trade execution remains disabled while strategy and exit modules are under development.

## [0.1.0-alpha] - 2026-09-09

### Added

- Initial MQL5 EA structure
- Configuration validation
- Domain enums, constants, and structured logging
- Repository documentation and MetaTrader build ignore rules
