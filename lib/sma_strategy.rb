class SmaStrategy
  def initialize stream
    @stream = stream
    @stream.on_value(&method(:on_sma))
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
