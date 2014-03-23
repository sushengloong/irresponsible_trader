# Buys every time you are not invested and stock price drops.
# Sell every time the stock price is more than LIMIT % higher than when you bought.
# Adapted from Sentdex Algorithmic Trading tutorial: http://bit.ly/1gW231h

module Strategy
  class SimpleStrategy < Base
    def initialize feeder, starting_capital, commission_per_trade, limit
      @feeder = feeder
      Frappuccino::Stream.new(feeder).
        select{ |event| event.has_key?(:bar) && event[:bar].present? }.
        map{ |event| event[:bar] }.
        on_value(&method(:on_bar))

      @portfolio = Portfolio::Base.new self, starting_capital, commission_per_trade
      @limit = limit
      @last_close = {}
    end

    def on_bar bar
      @date = bar.date
      bar.bar_data.each do |symbol, data|
        holding_num_shares = @portfolio.holdings.num_shares_for_symbol symbol
        current_close = data[:adj_close].to_f
        last_close = @last_close[symbol].to_f
        change = current_close - last_close

        # TODO to refactor - violate tell don't ask
        cheapest_holding_price = @portfolio.holdings.cheapest_price_for_symbol symbol
        if cheapest_holding_price.blank?
          profit_estimate_pct = 0
        else
          profit_estimate_pct = (current_close - cheapest_holding_price).to_f / cheapest_holding_price * 100
        end

        trade_type = if holding_num_shares == 0 && change < 0
                       :buy
                     elsif holding_num_shares > 0 && profit_estimate_pct > @limit
                       :sell
                     end

        # keep current's adj_close so that on next bar we can
        # refer to the last bar's adj_close
        @last_close[symbol] = current_close

        if trade_type.present?
          # TODO look-ahead bias here - should only place order on the next bar
          emit symbol: symbol, type: trade_type, price: current_close
        end
      end
    end
  end
end
