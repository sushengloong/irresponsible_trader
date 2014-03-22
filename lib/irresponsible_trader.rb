module IrresponsibleTrader
  require 'active_support'
  require 'active_support/time'
  require 'typhoeus'
  require 'csv'
  require 'awesome_print'
  require 'frappuccino'

  $last_closing_prices = {}
  $last_date = nil

  require_relative 'feeder'
  require_relative 'bar'
  require_relative 'bar_data'
  require_relative 'sma'
  require_relative 'sma_strategy'
  require_relative 'portfolio'
end
