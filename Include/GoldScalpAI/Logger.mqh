#ifndef GOLD_SCALP_AI_LOGGER_MQH
#define GOLD_SCALP_AI_LOGGER_MQH

#include "Enums.mqh"

class CGSALogger
  {
private:
   ENUM_GSA_LOG_LEVEL m_minimum_level;

   string LevelName(const ENUM_GSA_LOG_LEVEL level) const
     {
      switch(level)
        {
         case GSA_LOG_ERROR:   return "ERROR";
         case GSA_LOG_WARNING: return "WARN";
         case GSA_LOG_INFO:    return "INFO";
         case GSA_LOG_DEBUG:   return "DEBUG";
        }
      return "UNKNOWN";
     }

public:
   CGSALogger(void) : m_minimum_level(GSA_LOG_INFO) {}

   void SetMinimumLevel(const ENUM_GSA_LOG_LEVEL level)
     {
      m_minimum_level=level;
     }

   void Write(const ENUM_GSA_LOG_LEVEL level,const string message) const
     {
      if(level>m_minimum_level)
         return;

      PrintFormat("[GoldScalpAI][%s][%s] %s",
                  TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS),
                  LevelName(level),
                  message);
     }

   void Info(const string message) const { Write(GSA_LOG_INFO,message); }
   void Warning(const string message) const { Write(GSA_LOG_WARNING,message); }
   void Error(const string message) const { Write(GSA_LOG_ERROR,message); }
  };

#endif
