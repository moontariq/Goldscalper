# GoldScalper

Professional MT5 Expert Advisor (EA) foundation for gold scalping.

## Current version: v0.9.0-alpha

The EA now renders a compact on-chart status dashboard using the terminal's `Comment` area. It reports the EA state, EMA trend, market structure, signal direction/confidence, owned-position presence, and whether a dry-run trade plan is validated.

## Dashboard safeguards

- Dashboard values are refreshed only once per newly closed signal candle.
- Set `InpShowDashboard` to `false` to disable the chart display.
- The display is cleared when the EA is removed.
- Dashboard rendering is informational only; it does not alter orders or positions.

## Current safety posture

Entry plans and exit recommendations remain dry-run only. GoldScalper does not open, modify, or close trades in v0.9.

## Remaining alpha roadmap

1. v0.10 — trade statistics and alert-ready event records
2. v0.11 — backtesting, optimization, and execution-safety review documentation
3. Manual MT5 test review before considering any live-execution feature
