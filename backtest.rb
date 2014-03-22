#!/usr/bin/env ruby

require_relative 'lib/irresponsible_trader'

feeder = Feeder.new(1.years.ago.to_date,
                    Date.today,
                    %w{ AAPL GOOG MSFT FB TWTR })
feeder_stream = Frappuccino::Stream.new feeder

ta_stream = Frappuccino::Stream.new SimpleMovingAverage.new(feeder_stream, 25, 150)

strategy_stream = Frappuccino::Stream.new SmaStrategy.new(ta_stream)

Frappuccino::Stream.new Portfolio.new(strategy_stream, 10000, 25)

feeder.fetch
feeder.start
