module Portfolio
  class Holding
    attr_reader :symbol, :transacted_price, :num_shares

    def initialize symbol, transacted_price, num_shares
      @symbol = symbol.to_sym
      @transacted_price = transacted_price.to_f
      @num_shares = num_shares.to_i
    end

    # sell as much as @num_shares to fullfil order_num_shares
    def sell order_num_shares
      if order_num_shares <= @num_shares
        transacted_num_shares = order_num_shares
        @num_shares -= order_num_shares
      else
        transacted_num_shares = @num_shares
        @num_shares = 0
      end
      transacted_num_shares
    end
  end
end
