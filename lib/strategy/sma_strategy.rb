# A sample strategy using Simple Moving Average.

require_relative '../technical/sma'

module Strategy
  class SmaStrategy < Base
    def initialize feeder, starting_capital, commission_per_trade
      @feeder = feeder
      @feeder_stream = Frappuccino::Stream.new feeder
      @sma_stream = Frappuccino::Stream.new SimpleMovingAverage.new(@feeder_stream, 7, 20)
      @sma_stream.on_value(&method(:on_sma))
      Frappuccino::Stream.new Portfolio::Base.new(self, starting_capital, commission_per_trade)
    end

    def on_sma sma
      symbol = sma[0]
      bar_data = sma[1]
      fast_sma = sma[2]
      slow_sma = sma[3]
      close = bar_data[:adj_close]

      if fast_sma.present? && slow_sma.present?
        type = if fast_sma >= slow_sma
                 :buy
               else
                 :sell
               end
        emit symbol: symbol, type: type, num_shares: 1, price: close
      end
    end
  end
end
