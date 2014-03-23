module Portfolio
  class Base
    attr_reader :cash, :holdings, :commission_per_trade

    def initialize strategy, cash, commission_per_trade
      @strategy_stream = Frappuccino::Stream.new strategy
      @strategy_stream.on_value(&method(:on_order))

      @cash = cash
      @starting_capital = @cash

      @holdings = Holdings.new
      @commission_per_trade = commission_per_trade
      @total_commissions = 0.0

      p "Start new portfolio with cash $#{@cash}"
    end

    def on_order order
      market_order(*order_details(order))

      summary.each { |l| p l }
      puts
    end

    def order_details order
      type = order[:type]
      symbol = order[:symbol]
      price = order[:price].to_f

      # when :num_shares is blank, trader
      # wants to max out his cash to buy
      # as many shares as possible.
      num_shares = if order[:num_shares].blank?
                     (@cash / price).floor
                   else
                     order[:num_shares].to_i
                   end
      [symbol, type, price, num_shares]
    end

    def market_order symbol, type, price, num_shares
      value = num_shares * price

      if value == 0.0
        no_order symbol, price, num_shares
      elsif type == :buy
        enter_long symbol, price, num_shares
      else
        enter_long symbol, price, num_shares
      end
    end

    def no_order symbol, price, num_shares
      p "no order"
    end

    def enter_long symbol, price, num_shares
      value = price * num_shares
      if value > @cash
        p "not enough cash to buy"
      else
        @cash = (@cash - value).round 3
        @total_commissions += @commission_per_trade
        @holdings.buy symbol, price, num_shares
        p "[Enter Long] Buy #{num_shares} share(s) @ $#{price} and broker fee @ $#{@commission_per_trade} flat"
      end
    end

    def exit_long symbol, price, num_shares
      transacted_num_shares = @holdings.sell symbol, num_shares
      value = price * transacted_num_shares
      @cash = (@cash - value).round 3
      @total_commissions += @commission_per_trade

      p "[Exit Long] Sell #{transacted_num_shares} share(s) @ $#{price} and broker fee @ $#{@commission_per_trade} flat"
    end

    def summary
      [
        "Date: #{$last_date}",
        "Cash In Hand: $#{@cash}",
        "Total Commissions Paid: $#{@total_commissions}",
        "Total Holding Value: $#{@holdings.total_value}",
        @holdings.summary,
        "Profit: $#{(@cash + @holdings.total_value - @total_commissions - @starting_capital).round(3)}",
        '==============='
      ]
    end
  end
end
