#ifndef GOLD_SCALP_AI_SESSION_MANAGER_MQH
#define GOLD_SCALP_AI_SESSION_MANAGER_MQH

class CGSASessionManager
  {
private:
   int m_start_minute;
   int m_end_minute;

public:
   CGSASessionManager(void) : m_start_minute(0),m_end_minute(1439) {}

   bool Initialize(const int start_hour,const int end_hour)
     {
      if(start_hour<0 || start_hour>23 || end_hour<0 || end_hour>23)
         return false;

      m_start_minute=start_hour*60;
      // Existing inputs define inclusive full hours, preserving v0.11 behavior.
      m_end_minute=end_hour*60+59;
      return true;
     }

   bool IsActive(const datetime server_time=0) const
     {
      datetime checked_time=server_time;
      if(checked_time==0)
         checked_time=TimeTradeServer();
      if(checked_time==0)
         checked_time=TimeCurrent();

      MqlDateTime date_time={};
      TimeToStruct(checked_time,date_time);
      const int current_minute=date_time.hour*60+date_time.min;

      if(m_start_minute<=m_end_minute)
         return (current_minute>=m_start_minute && current_minute<=m_end_minute);

      return (current_minute>=m_start_minute || current_minute<=m_end_minute);
     }
  };

#endif
