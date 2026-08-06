# GoldScalper

Professional MT5 Expert Advisor (EA) foundation for gold scalping.

## Principles

- Capital preservation first
- No martingale and no grid trading
- Small-account aware risk controls
- Modular, testable MQL5 architecture
- Strategy execution is disabled until market, risk, and entry modules are complete

## Initial layout

- `Experts/GoldScalpAI.mq5` — EA entry point and lifecycle
- `Include/GoldScalpAI/Config.mqh` — validated runtime configuration
- `Include/GoldScalpAI/Enums.mqh` — domain types
- `Include/GoldScalpAI/Constants.mqh` — shared limits and identifiers
- `Include/GoldScalpAI/Logger.mqh` — structured terminal logging

## Roadmap

1. Foundation and configuration
2. Risk, trade, and broker managers
3. Market/session analysis
4. Price action and smart-money entry engine
5. Exit, dashboard, statistics, and alerts
6. Backtesting, optimization, and release documentation
