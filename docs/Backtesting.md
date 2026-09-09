# MT5 Backtesting Protocol

## Scope

GoldScalper is dry-run only through v0.11. This protocol validates analysis, planning, dashboard, statistics, and exit recommendations. Do not enable live execution.

## Test setup

1. Compile `Experts/GoldScalpAI.mq5` in MetaEditor and resolve every compiler error and warning.
2. Use a broker-specific XAUUSD symbol with the correct contract specifications.
3. Run Strategy Tester in **Every tick based on real ticks** mode.
4. Test at least M5 signals across varied volatility periods.
5. Keep `InpAllowTrading=false`; inspect `DRY RUN`, `EVENT`, `STATS TODAY`, and `EXIT DRY RUN` messages.

## Acceptance checks

- No order placement, modification, or close is generated.
- One analysis cycle occurs per closed signal candle.
- Spread, session, daily-loss, and capacity filters block invalid plans.
- Every valid plan has broker-valid stop distance and non-zero risk-based volume.
- Existing positions produce only read-only exit recommendations.
- Dashboard state agrees with terminal logs.

## Optimization discipline

Optimize only after a baseline backtest is saved. Change one parameter family per run:

- EMA / ATR periods
- Swing strength and structure lookback
- Confidence threshold
- ATR stop multiplier and reward ratio
- Session and spread limits

Use out-of-sample validation; never choose settings solely from the best in-sample result.
