# GoldScalper

Professional MT5 Expert Advisor (EA) foundation for gold scalping.

## Current version: v0.6.0-alpha

The EA now produces an explainable, deterministic confidence score from trend, confirmed market structure, and ATR availability. Signals must meet the configurable confidence threshold before they can progress to a future execution layer. Trade execution remains disabled.

## Principles

- Capital preservation first
- No martingale and no grid trading
- Small-account aware risk controls
- Modular, testable MQL5 architecture
- Strategy execution is disabled until market, risk, and entry modules are complete

## Signal qualification

- Bullish EMA trend + bullish break of structure: buy direction, 85 confidence
- Bearish EMA trend + bearish break of structure: sell direction, 85 confidence
- Trend-aligned range: directional watch signal, 45 confidence
- Missing or conflicting evidence: no signal

The default minimum confidence is 75, so only full trend-and-structure confluence qualifies.

## Roadmap

1. Foundation, protection, analysis, and qualification
2. Execution planning and exit management
3. Dashboard, statistics, and alerts
4. Backtesting, optimization, and release documentation
