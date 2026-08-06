# GoldScalper

Professional MT5 Expert Advisor (EA) foundation for gold scalping.

## Current version: v0.2.0-alpha

The EA now includes a safety layer that validates the symbol, active server-time trading session, and live spread before any future strategy code can run. Trade execution remains disabled while the entry and exit engines are under development.

## Principles

- Capital preservation first
- No martingale and no grid trading
- Small-account aware risk controls
- Modular, testable MQL5 architecture
- Strategy execution is disabled until market, risk, and entry modules are complete

## Current layout

- `Experts/GoldScalpAI.mq5` — EA lifecycle and safety pipeline
- `Include/GoldScalpAI/Config.mqh` — validated runtime configuration
- `Include/GoldScalpAI/Enums.mqh` — domain types
- `Include/GoldScalpAI/Constants.mqh` — shared limits and version identifier
- `Include/GoldScalpAI/Logger.mqh` — structured terminal logging
- `Include/GoldScalpAI/RiskManager.mqh` — risk-based position sizing
- `Include/GoldScalpAI/MarketGuard.mqh` — tradability and spread checks
- `Include/GoldScalpAI/SessionManager.mqh` — server-time session filtering

## Roadmap

1. Foundation and configuration
2. Risk, trade, and broker managers
3. Market/session analysis
4. Price action and smart-money entry engine
5. Exit, dashboard, statistics, and alerts
6. Backtesting, optimization, and release documentation
