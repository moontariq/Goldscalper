#ifndef GOLD_SCALP_AI_SESSION_MANAGER_MQH
#define GOLD_SCALP_AI_SESSION_MANAGER_MQH

class CGSASessionManager
  {
private:
   int m_start_hour;
   int m_end_hour;

public:
   CGSASessionManager(void) : m_start_hour(0),m_end_hour(23) {}

   bool Initialize(const int start_hour,const int end_hour)
     {
      if(start_hour<0 || start_hour>23 || end_hour<0 || end_hour>23)
         return false;

      m_start_hour=start_hour;
      m_end_hour=end_hour;
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
      const int hour=date_time.hour;

      if(m_start_hour<=m_end_hour)
         return (hour>=m_start_hour && hour<=m_end_hour);

      return (hour>=m_start_hour || hour<=m_end_hour);
     }
  };

#endif
