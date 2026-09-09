# Execution Safety Review

## Current capability

v0.11 does **not** call any MQL5 API to open, modify, or close a trade. It is safe for dry-run analysis in the sense that it cannot submit orders from its own code path.

## Mandatory gates before any future execution feature

- Successful MetaEditor compile with no warnings
- Strategy Tester validation on real ticks
- Forward test on a demo account
- Broker-symbol review: volume steps, stops level, freeze level, fill policy, and trading sessions
- Independent review of each order, modification, and close path
- Conservative limits for daily loss, maximum positions, spread, and risk per trade
- User approval for enabling a specific execution mode

## Do not enable live execution merely because a plan is valid

A validated plan is a calculated proposal, not evidence of profitability or suitability. Historical and demo results do not guarantee future outcomes.
