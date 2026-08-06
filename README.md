# GoldScalper

Professional MT5 Expert Advisor (EA) foundation for gold scalping.

## Current version: v0.5.0-alpha

The EA now analyses confirmed swing highs and lows, then classifies a basic break of structure (bullish, bearish, or range) from completed candles. This provides a conservative price-action and Smart Money Concepts foundation for future entry rules. Trade execution remains disabled.

## Principles

- Capital preservation first
- No martingale and no grid trading
- Small-account aware risk controls
- Modular, testable MQL5 architecture
- Strategy execution is disabled until market, risk, and entry modules are complete

## Current analysis modules

- `MarketData.mqh` — closed-bar series retrieval
- `IndicatorManager.mqh` — EMA and ATR handle lifecycle
- `TrendAnalyzer.mqh` — EMA trend classification
- `PriceActionAnalyzer.mqh` — confirmed swing-high and swing-low detection
- `SmartMoneyAnalyzer.mqh` — basic break-of-structure classification

## Roadmap

1. Foundation, capital protection, and analysis
2. Confluence scoring and entry qualification
3. Entry and exit engines
4. Dashboard, statistics, and alerts
5. Backtesting, optimization, and release documentation
