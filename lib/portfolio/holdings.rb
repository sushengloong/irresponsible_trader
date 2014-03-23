module Portfolio
  class Holdings

    def initialize
      @holdings = []
    end

    def buy symbol, price, num_shares
      holding = Holding.new(symbol, price, num_shares)
      @holdings << holding
      clear_empty_holdings
      holding
    end

    # this decides on which shares to sell off
    # we try to clear shares bought at cheaper price
    def sell symbol, num_shares
      transacted_num_shares = 0
      holdings_for_symbol(symbol).each do |holding|
        unfilled = num_shares - transacted_num_shares
        break if unfilled == 0
        transacted_num_shares += holding.sell(unfilled)
      end
      clear_empty_holdings
      transacted_num_shares
    end

    def holdings_for_symbol symbol
      @holdings.select { |holding| holding.symbol == symbol }.
        sort_by { |holding| holding.transacted_price }
    end

    def num_shares_for_symbol symbol
      holdings_for_symbol(symbol).inject(0) { |sum, holding| sum + holding.num_shares }
    end

    def cheapest_price_for_symbol symbol
      holdings_for_symbol(symbol).map { |holding| holding.transacted_price }.min
    end

    def total_value
      @holdings.inject(0) do |sum, holding|
        last_close = $last_closing_prices[holding.symbol][:adj_close].to_f
        (sum + holding.num_shares * last_close).round(3)
      end
    end

    def summary
      @holdings.map do |holding|
        last_close = $last_closing_prices[holding.symbol][:adj_close].to_f
        value = (holding.num_shares * last_close).round 3
        "#{holding.symbol}: #{holding.num_shares} x $#{last_close} = $#{value}"
      end
    end

    private

    def clear_empty_holdings
      @holdings.reject!{ |holding| holding.num_shares.to_i <= 0 }
    end
  end
end
