# GoldScalper

Professional MT5 Expert Advisor (EA) foundation for gold scalping.

## Current version: v0.7.0-alpha

The EA can now turn a qualified signal into a validated, execution-free trade plan. The plan calculates a live bid/ask entry, ATR-based stop loss, risk-reward take profit, broker-compatible stop distance, and risk-based volume. It does not send an order.

## Planning safeguards

- Only qualified high-confidence signals can create a plan.
- Stop loss is derived from ATR and must satisfy the broker stop-distance rule.
- Volume is calculated from the configured percentage risk and stop distance.
- The plan is rejected if any input, price, broker constraint, or volume is invalid.

## Roadmap

1. Foundation, protection, analysis, qualification, and planning
2. Reviewable execution and position lifecycle management
3. Dashboard, statistics, and alerts
4. Backtesting, optimization, and release documentation
