#ifndef GOLD_SCALP_AI_ALERT_LOGGER_MQH
#define GOLD_SCALP_AI_ALERT_LOGGER_MQH

#include "Logger.mqh"

class CGSAAlertLogger
  {
private:
   const CGSALogger *m_logger;

public:
   CGSAAlertLogger(void) : m_logger(NULL) {}

   void Initialize(const CGSALogger &logger)
     {
      m_logger=&logger;
     }

   void Emit(const string event_name,const string detail) const
     {
      if(m_logger!=NULL)
         m_logger->Info(StringFormat("EVENT %s | %s",event_name,detail));
     }
  };

#endif
