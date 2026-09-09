# Safety Audit Issue Register

## Resolved in audit working copy

| ID | Priority | Problem | Fix | Validation |
|---|---|---|---|---|
| P0-001 | P0 | Daily limit was recalculated from changing balance. | Persisted/reconstructed start-of-server-day balance; loss limit is now fixed from that baseline. | Static caller review; requires MT5 restart/day-boundary test. |
| P0-002 | P0 | Risk sizing did not verify actual loss after volume normalization. | Recalculate normalized-volume loss with `OrderCalcProfit`; reject if it exceeds allowed risk. | Static safety-path review. |
| P0-003 | P0 | Planned volume had no margin test. | Added `OrderCalcMargin` free-margin check with buffer before plan validation. | Static safety-path review. |
| P0-004 | P0 | Position reader/exit flow assumed one owned position. | Added filtered all-owned-position iteration and per-ticket exit recommendation loop. | Static caller review. |
| P0-005 | P0 | Broker configuration/direction checks were incomplete. | Added symbol selection, tick/contract, volume, direction, and margin validation. | Static safety-path review. |

## Open validation blockers

| ID | Priority | Problem | Required evidence | Status |
|---|---|---|---|---|
| V-001 | P0 | MetaEditor compile not available in this environment. | MetaEditor compile log with zero errors/warnings. | BLOCKED externally |
| V-002 | P0 | Real-tick, broker-specific backtest unavailable. | MT5 Strategy Tester report and journal. | BLOCKED externally |
| V-003 | P1 | SMC is deterministic basic BOS only, not full SMC/CHOCH/FVG/OB. | Requirements/design plus unit/backtest evidence. | OPEN, not live-ready |
| V-004 | P1 | Statistics do not yet provide full expectancy/drawdown/slippage/session/set-up metrics. | Deterministic history tests and report. | OPEN, not live-ready |

## Safety status

`LIVE EXECUTION: DISABLED` — source contains no `OrderSend`, `CTrade`, `PositionModify`, or `PositionClose` call.
