# GoldScalper

Professional MT5 Expert Advisor (EA) foundation for gold scalping.

## Current version: v0.3.0-alpha

The EA now has layered capital-protection controls. Before future strategy code can run, it validates the symbol, server-time session, live spread, daily realized loss limit, and capacity for the configured number of positions. Trade execution remains disabled while the entry and exit engines are under development.

## Principles

- Capital preservation first
- No martingale and no grid trading
- Small-account aware risk controls
- Modular, testable MQL5 architecture
- Strategy execution is disabled until market, risk, and entry modules are complete

## Current layout

- `Experts/GoldScalpAI.mq5` — EA lifecycle and safety pipeline
- `Include/GoldScalpAI/BrokerManager.mqh` — terminal and stop-distance constraints
- `Include/GoldScalpAI/Config.mqh` — validated runtime configuration
- `Include/GoldScalpAI/DailyLossGuard.mqh` — realized daily-loss circuit breaker
- `Include/GoldScalpAI/Logger.mqh` — structured terminal logging
- `Include/GoldScalpAI/MarketGuard.mqh` — tradability and spread checks
- `Include/GoldScalpAI/RiskManager.mqh` — risk-based position sizing
- `Include/GoldScalpAI/SessionManager.mqh` — server-time session filtering
- `Include/GoldScalpAI/TradeManager.mqh` — position-capacity checks

## Roadmap

1. Foundation and capital protection
2. Market data and indicator layer
3. Price action and smart-money analysis
4. Entry and exit engines
5. Dashboard, statistics, and alerts
6. Backtesting, optimization, and release documentation
