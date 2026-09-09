#ifndef GOLD_SCALP_AI_EQUITY_GUARD_MQH
#define GOLD_SCALP_AI_EQUITY_GUARD_MQH

class CGSAEquityGuard
  {
public:
   bool IsWithinDrawdownLimit(const double reference_balance,const double maximum_loss_percent) const
     {
      if(reference_balance<=0.0 || maximum_loss_percent<=0.0)
         return false;
      const double equity=AccountInfoDouble(ACCOUNT_EQUITY);
      const double floor=reference_balance*(1.0-maximum_loss_percent/100.0);
      return (equity>floor);
     }

   double FloatingProfit(void) const
     {
      return AccountInfoDouble(ACCOUNT_EQUITY)-AccountInfoDouble(ACCOUNT_BALANCE);
     }
  };

#endif
