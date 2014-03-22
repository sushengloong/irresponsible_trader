class Portfolio
  attr_reader :cash, :holdings, :commission_per_trade

  def initialize stream, cash, commission_per_trade
    @stream = stream
    @stream.on_value(&method(:on_order))
    @cash = cash
    @holdings = {}
    @commission_per_trade = commission_per_trade
    @total_commissions = 0.0
    p "Start new portfolio with cash $#{@cash}"
  end

  def on_order order
    symbol = order[:symbol]
    @holdings[symbol] ||= 0

    diff = case order[:type]
           when :buy
             order[:num_shares].to_i
           when :sell
             -order[:num_shares].to_i
           end
    value = diff * order[:price].to_f

    if order[:type] == :buy && value > @cash
      p "not enough cash to buy"
    else
      @holdings[symbol] += diff
      @cash = (@cash - value).round 3
      @total_commissions += @commission_per_trade
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
      '===============',
      "Date: #{$last_date}",
      "Cash: $#{@cash}",
      "Total Holding Value: $#{total_value}",
      "Total Commissions Paid: $#{@total_commissions}",
      @holdings.map do |k, v|
        last_close = $last_closing_prices[k][:adj_close].to_f
        value = (v * last_close).round 3
        "#{k}: #{v} x $#{last_close} = $#{value}"
      end,
      '==============='
    ]
  end
end
