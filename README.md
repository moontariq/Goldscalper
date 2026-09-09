# GoldScalper

Professional MT5 Expert Advisor (EA) foundation for gold scalping.

## Current version: v0.11.0-alpha

GoldScalper now includes dry-run planning, read-only exit recommendations, an on-chart status dashboard, daily realized-trade statistics, and local structured event records. It still cannot open, modify, or close a trade.

## v0.10 observability

- `STATS TODAY` logs closed deals, wins, losses, and net result for the EA symbol/magic number.
- `EVENT QUALIFIED_PLAN` records each qualified dry-run entry plan.
- `EVENT EXIT_RECOMMENDATION` records a suggested break-even or trailing level.
- These are local terminal logs only; they send no notifications and create no trading side effects.

## v0.11 test and release-readiness material

- [MT5 backtesting protocol](docs/Backtesting.md)
- [Execution safety review](docs/ExecutionSafetyReview.md)
- [Optimization run log template](docs/OptimizationLog.template.md)

## Required before any execution feature

Compile cleanly in MetaEditor, validate with real-tick Strategy Tester runs, forward-test on a demo account, and perform the documented execution-safety review. Historical and demo performance do not guarantee future outcomes.
