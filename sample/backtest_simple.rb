#!/usr/bin/env ruby

require_relative '../lib/irresponsible_trader'

# set up trading configuration
start_date = 10.years.ago.to_date
end_date = Date.current
stock_symbols = %w{ MSFT }
starting_capital = 10_000
commission_per_trade = 10

# Initialize feeder to fetch prices data from Yahoo Finance
feeder = Feeder.new start_date,
                    end_date,
                    stock_symbols

# Initialize custom strategy with the feeder.
simple_strategy = Strategy::SimpleStrategy.new feeder, starting_capital, commission_per_trade

# Begin backtesting
simple_strategy.start
