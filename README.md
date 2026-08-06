# GoldScalper

Professional MT5 Expert Advisor (EA) foundation for gold scalping.

## Current version: v0.4.0-alpha

The EA now provides a data and indicator layer for the selected signal timeframe. It reads only completed bars, manages EMA and ATR indicator handles safely, and classifies the market trend from the fast/slow EMA relationship. Trade execution remains disabled while the entry and exit engines are under development.

## Principles

- Capital preservation first
- No martingale and no grid trading
- Small-account aware risk controls
- Modular, testable MQL5 architecture
- Strategy execution is disabled until market, risk, and entry modules are complete

## Current layout

- `Experts/GoldScalpAI.mq5` — EA lifecycle and analysis pipeline
- `Include/GoldScalpAI/MarketData.mqh` — closed-bar market data access
- `Include/GoldScalpAI/IndicatorManager.mqh` — EMA and ATR handle lifecycle
- `Include/GoldScalpAI/TrendAnalyzer.mqh` — EMA trend classification
- `Include/GoldScalpAI/BrokerManager.mqh` — terminal and stop-distance constraints
- `Include/GoldScalpAI/DailyLossGuard.mqh` — realized daily-loss circuit breaker
- `Include/GoldScalpAI/RiskManager.mqh` — risk-based position sizing
- `Include/GoldScalpAI/TradeManager.mqh` — position-capacity checks

## Roadmap

1. Foundation, capital protection, and market data
2. Price action and smart-money analysis
3. Entry and exit engines
4. Dashboard, statistics, and alerts
5. Backtesting, optimization, and release documentation
