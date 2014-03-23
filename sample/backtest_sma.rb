#!/usr/bin/env ruby

require_relative '../lib/irresponsible_trader'

# set up trading configuration
start_date = 6.months.ago.to_date
end_date = Date.current
stock_symbols = %w{ AAPL GOOG MSFT }
starting_capital = 10_000
commission_per_trade = 25

# Initialize feeder to fetch prices data from Yahoo Finance
feeder = Feeder.new start_date,
                    end_date,
                    stock_symbols

# Initialize custom strategy with the feeder.
# Strategy::SmaStrategy is a sample strategy which compares
# slow and fast simple moving averages.
sma_strategy = Strategy::SmaStrategy.new feeder, starting_capital, commission_per_trade

# Begin backtesting
sma_strategy.start
