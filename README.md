# GoldScalper

Professional MT5 Expert Advisor (EA) foundation for gold scalping.

## Current version: v0.7.0-alpha

The EA can turn a qualified signal into a validated, execution-free trade plan. The plan calculates a live bid/ask entry, ATR-based stop loss, risk-reward take profit, broker-compatible stop distance, and risk-based volume. It does not send an order.

## Completed v0.7 dry-run workflow

- A plan is evaluated only once for each newly closed signal-timeframe candle.
- The EA can log each accepted plan in the terminal as `DRY RUN` for manual review.
- Set `InpLogTradePlans` to `false` to suppress those logs.
- The output includes direction, confidence, entry, stop loss, take profit, and volume.
- No MQL5 trade-request API is invoked; `InpAllowTrading` does not enable entries in v0.7.

## Planning safeguards

- Only qualified high-confidence signals can create a plan.
- Stop loss is derived from ATR and must satisfy the broker stop-distance rule.
- Volume is calculated from the configured percentage risk and stop distance.
- The plan is rejected if any input, price, broker constraint, or volume is invalid.

## Roadmap

1. Foundation, protection, analysis, qualification, and dry-run planning
2. Reviewable execution and position lifecycle management
3. Dashboard, statistics, and alerts
4. Backtesting, optimization, and release documentation
