#ifndef GOLD_SCALP_AI_CLOSED_BAR_GATE_MQH
#define GOLD_SCALP_AI_CLOSED_BAR_GATE_MQH

class CGSAClosedBarGate
  {
private:
   datetime m_last_processed_time;

public:
   CGSAClosedBarGate(void) : m_last_processed_time(0) {}

   bool IsNew(const datetime closed_bar_time)
     {
      if(closed_bar_time<=0 || closed_bar_time==m_last_processed_time)
         return false;

      m_last_processed_time=closed_bar_time;
      return true;
     }
  };

#endif
