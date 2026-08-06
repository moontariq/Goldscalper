#ifndef GOLD_SCALP_AI_RISK_MANAGER_MQH
#define GOLD_SCALP_AI_RISK_MANAGER_MQH

#include "Config.mqh"
#include "Enums.mqh"

class CGSARiskManager
  {
private:
   int VolumeDigits(const double step) const
     {
      int digits=0;
      double scaled=step;
      while(digits<8 && MathAbs(scaled-MathRound(scaled))>0.00000001)
        {
         scaled*=10.0;
         digits++;
        }
      return digits;
     }

public:
   double CalculateVolume(const CGSAConfig &config,const ENUM_GSA_TRADE_DIRECTION direction,
                          const double entry_price,const double stop_loss_price) const
     {
      if(direction==GSA_DIRECTION_NONE || entry_price<=0.0 || stop_loss_price<=0.0)
         return 0.0;

      const ENUM_ORDER_TYPE order_type=(direction==GSA_DIRECTION_BUY ? ORDER_TYPE_BUY : ORDER_TYPE_SELL);
      double loss_per_lot=0.0;
      if(!OrderCalcProfit(order_type,_Symbol,1.0,entry_price,stop_loss_price,loss_per_lot))
         return 0.0;

      loss_per_lot=MathAbs(loss_per_lot);
      if(loss_per_lot<=0.0)
         return 0.0;

      const double risk_money=AccountInfoDouble(ACCOUNT_BALANCE)*config.RiskPercent()/100.0;
      const double raw_volume=risk_money/loss_per_lot;
      const double min_volume=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
      const double max_volume=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
      const double volume_step=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
      if(min_volume<=0.0 || max_volume<min_volume || volume_step<=0.0)
         return 0.0;

      const double normalized=MathFloor(raw_volume/volume_step)*volume_step;
      if(normalized<min_volume)
         return 0.0;

      return NormalizeDouble(MathMin(normalized,max_volume),VolumeDigits(volume_step));
     }
  };

#endif
