#ifndef GOLD_SCALP_AI_PRICE_ACTION_ANALYZER_MQH
#define GOLD_SCALP_AI_PRICE_ACTION_ANALYZER_MQH

class CGSAPriceActionAnalyzer
  {
public:
   bool FindLatestSwingHigh(const MqlRates &bars[],const int bar_count,
                            const int strength,double &price) const
     {
      if(strength<1 || bar_count<(strength*2+1))
         return false;

      for(int index=strength;index<bar_count-strength;index++)
        {
         bool is_swing=true;
         for(int offset=1;offset<=strength;offset++)
           {
            if(bars[index].high<=bars[index-offset].high ||
               bars[index].high<=bars[index+offset].high)
              {
               is_swing=false;
               break;
              }
           }
         if(is_swing)
           {
            price=bars[index].high;
            return true;
           }
        }
      return false;
     }

   bool FindLatestSwingLow(const MqlRates &bars[],const int bar_count,
                           const int strength,double &price) const
     {
      if(strength<1 || bar_count<(strength*2+1))
         return false;

      for(int index=strength;index<bar_count-strength;index++)
        {
         bool is_swing=true;
         for(int offset=1;offset<=strength;offset++)
           {
            if(bars[index].low>=bars[index-offset].low ||
               bars[index].low>=bars[index+offset].low)
              {
               is_swing=false;
               break;
              }
           }
         if(is_swing)
           {
            price=bars[index].low;
            return true;
           }
        }
      return false;
     }
  };

#endif
