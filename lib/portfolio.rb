class Portfolio
  attr_reader :cash, :holdings, :commission_per_trade

  def initialize strategy, cash, commission_per_trade
    @strategy_stream = Frappuccino::Stream.new strategy
    @strategy_stream.on_value(&method(:on_order))

    @cash = cash
    @starting_capital = @cash

    @holdings = {}
    @commission_per_trade = commission_per_trade
    @total_commissions = 0.0

    p "Start new portfolio with cash $#{@cash}"
  end

  def on_order order
    symbol, type, price, num_shares = order_details order

    @holdings[symbol] ||= 0
    market_order symbol, type, price, num_shares

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
    signed_diff = if type == :sell
                    num_shares * -1.0
                  else
                    num_shares
                  end
    signed_value = signed_diff * price

    if signed_diff == 0
      p "no order"
    elsif type == :buy && signed_value > @cash
      p "not enough cash to buy"
    else
      @holdings[symbol] += signed_diff
      @cash = (@cash - signed_value).round 3
      @total_commissions += @commission_per_trade

      p "#{type} #{num_shares} share(s) @ $#{price}"
    end
  end

  def total_value
    @holdings.inject(0) do |sum, (symbol, num_shares)|
      (sum + num_shares * $last_closing_prices[symbol][:adj_close].to_f).round(3)
    end
  end

  def summary
    [
      "Date: #{$last_date}",
      "Cash In Hand: $#{@cash}",
      "Total Commissions Paid: $#{@total_commissions}",
      "Total Holding Value: $#{total_value}",
      @holdings.map do |k, v|
        last_close = $last_closing_prices[k][:adj_close].to_f
        value = (v * last_close).round 3
        "#{k}: #{v} x $#{last_close} = $#{value}"
      end,
      "Profit: $#{(@cash + total_value - @total_commissions - @starting_capital).round(3)}",
      '==============='
    ]
  end
end
