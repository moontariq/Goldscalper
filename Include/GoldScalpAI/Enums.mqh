#ifndef GOLD_SCALP_AI_ENUMS_MQH
#define GOLD_SCALP_AI_ENUMS_MQH

enum ENUM_GSA_LOG_LEVEL
  {
   GSA_LOG_ERROR = 0,
   GSA_LOG_WARNING,
   GSA_LOG_INFO,
   GSA_LOG_DEBUG
  };

enum ENUM_GSA_TRADE_DIRECTION
  {
   GSA_DIRECTION_NONE = 0,
   GSA_DIRECTION_BUY,
   GSA_DIRECTION_SELL
  };

enum ENUM_GSA_MARKET_TREND
  {
   GSA_TREND_UNKNOWN = 0,
   GSA_TREND_BEARISH,
   GSA_TREND_NEUTRAL,
   GSA_TREND_BULLISH
  };

enum ENUM_GSA_MARKET_STRUCTURE
  {
   GSA_STRUCTURE_UNKNOWN = 0,
   GSA_STRUCTURE_RANGE,
   GSA_STRUCTURE_BEARISH_BREAK,
   GSA_STRUCTURE_BULLISH_BREAK
  };

struct GSA_SIGNAL_SCORE
  {
   ENUM_GSA_TRADE_DIRECTION direction;
   double                   confidence;
  };

struct GSA_TRADE_PLAN
  {
   bool                     valid;
   ENUM_GSA_TRADE_DIRECTION direction;
   double                   entry_price;
   double                   stop_loss;
   double                   take_profit;
   double                   volume;
   double                   confidence;
  };

enum ENUM_GSA_EA_STATE
  {
   GSA_STATE_INITIALIZING = 0,
   GSA_STATE_READY,
   GSA_STATE_PAUSED,
   GSA_STATE_ERROR
  };

#endif
