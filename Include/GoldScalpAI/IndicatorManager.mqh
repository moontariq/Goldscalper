#ifndef GOLD_SCALP_AI_INDICATOR_MANAGER_MQH
#define GOLD_SCALP_AI_INDICATOR_MANAGER_MQH

class CGSAIndicatorManager
  {
private:
   int m_fast_ema_handle;
   int m_slow_ema_handle;
   int m_atr_handle;

   bool ReadClosedValue(const int handle,double &value) const
     {
      if(handle==INVALID_HANDLE)
         return false;

      double values[];
      ArraySetAsSeries(values,true);
      if(CopyBuffer(handle,0,1,1,values)!=1)
         return false;

      value=values[0];
      return (value!=EMPTY_VALUE);
     }

public:
   CGSAIndicatorManager(void) : m_fast_ema_handle(INVALID_HANDLE),
                                m_slow_ema_handle(INVALID_HANDLE),
                                m_atr_handle(INVALID_HANDLE) {}

   bool Initialize(const ENUM_TIMEFRAMES timeframe,const int fast_ema_period,
                   const int slow_ema_period,const int atr_period)
     {
      Release();
      if(fast_ema_period<=0 || slow_ema_period<=fast_ema_period || atr_period<=0)
         return false;

      m_fast_ema_handle=iMA(_Symbol,timeframe,fast_ema_period,0,MODE_EMA,PRICE_CLOSE);
      m_slow_ema_handle=iMA(_Symbol,timeframe,slow_ema_period,0,MODE_EMA,PRICE_CLOSE);
      m_atr_handle=iATR(_Symbol,timeframe,atr_period);

      if(m_fast_ema_handle==INVALID_HANDLE || m_slow_ema_handle==INVALID_HANDLE ||
         m_atr_handle==INVALID_HANDLE)
        {
         Release();
         return false;
        }
      return true;
     }

   void Release(void)
     {
      if(m_fast_ema_handle!=INVALID_HANDLE)
         IndicatorRelease(m_fast_ema_handle);
      if(m_slow_ema_handle!=INVALID_HANDLE)
         IndicatorRelease(m_slow_ema_handle);
      if(m_atr_handle!=INVALID_HANDLE)
         IndicatorRelease(m_atr_handle);

      m_fast_ema_handle=INVALID_HANDLE;
      m_slow_ema_handle=INVALID_HANDLE;
      m_atr_handle=INVALID_HANDLE;
     }

   bool GetFastEma(double &value) const { return ReadClosedValue(m_fast_ema_handle,value); }
   bool GetSlowEma(double &value) const { return ReadClosedValue(m_slow_ema_handle,value); }
   bool GetAtr(double &value) const { return ReadClosedValue(m_atr_handle,value); }
  };

#endif
