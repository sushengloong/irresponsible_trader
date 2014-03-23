module IrresponsibleTrader
  require 'active_support'
  require 'active_support/time'
  require 'typhoeus'
  require 'csv'
  require 'awesome_print'
  require 'frappuccino'

  # configure application timezone
  Time.zone_default = Time.find_zone! 'Singapore'

  $last_closing_prices = {}
  $last_date = nil

  require_relative 'feeder'
  require_relative 'bar'
  require_relative 'bar_data'
  require_relative 'strategy/all'
  require_relative 'portfolio/all'
end
