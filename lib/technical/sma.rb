module Technical
  class SimpleMovingAverage
    attr_reader :date, :periods

    def initialize stream, *periods
      @stream = stream.select{ |event| event.has_key?(:bar) && event[:bar].present? }.
        map{ |event| event[:bar] }
      @stream.on_value(&method(:on_bar))
      @periods = periods.map(&:to_i)
      @stocks = {}
    end

    def on_bar bar
      @date = bar.date
      bar.bar_data.each do |symbol, data|
        @stocks[symbol] ||= []
        @stocks[symbol] << data[:adj_close]
        sma = @periods.inject({}) do |acc, period|
          acc.merge period => for_symbol(symbol, period)
        end
        emit [symbol, data, sma[@periods[0]], sma[@periods[1]]]
      end
    end

    def for_symbol symbol, period
      @stocks[symbol].compact!
      return nil if @stocks[symbol].length < period
      (@stocks[symbol].reverse.slice(0, period).inject(:+).to_f / period).round 3
    end
  end
end
