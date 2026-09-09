# GoldScalper

Professional MT5 Expert Advisor (EA) foundation for gold scalping.

## Current version: v0.8.0-alpha

The EA now reads its own existing positions and produces read-only exit recommendations. Once a position reaches the configured reward multiple, it can recommend moving the stop loss to break-even and then propose an ATR-based trailing-stop level. It never modifies or closes a position.

## Exit planning safeguards

- Position data is read only for the current symbol and the EA's magic number.
- A recommendation is evaluated only once per newly closed signal candle.
- Break-even is considered only after the configured profit trigger is reached.
- Trailing is considered only when it improves upon the break-even stop level.
- Recommendations are logged as `EXIT DRY RUN`; no trade or position-modification request is invoked.

## Configuration

- `InpBreakEvenRiskMultiple` — profit target in initial-risk multiples before break-even can be recommended (default `1.0`).
- `InpTrailingStopAtrMultiplier` — ATR multiplier for the suggested trailing stop (default `1.0`).
- `InpLogTradePlans` — enables or suppresses both entry-plan and exit-plan dry-run logs.

## Roadmap

1. Foundation, protection, analysis, qualification, entry planning, and exit recommendations
2. Dashboard, statistics, and alerts
3. Backtesting, optimization, and execution-safety review
4. Production release documentation
