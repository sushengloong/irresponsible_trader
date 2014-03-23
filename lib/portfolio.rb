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
    symbol = order[:symbol]
    @holdings[symbol] ||= 0
    price = order[:price].to_f

    # when :num_shares is blank, trader
    # wants to max out his cash to buy
    # as many shares as possible.
    diff = if order[:num_shares].blank?
             (@cash / price).floor
           else
             order[:num_shares].to_i
           end

    diff = -diff if order[:type] == :sell
    value = diff * price

    if order[:type] == :buy && value > @cash
      p "not enough cash to buy"
    elsif diff.abs != 0
      @holdings[symbol] += diff
      @cash = (@cash - value).round 3
      @total_commissions += @commission_per_trade

      p "#{order[:type]} #{diff.abs} share(s) @ $#{price}"
    end

    summary.each { |l| p l }
    puts
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
