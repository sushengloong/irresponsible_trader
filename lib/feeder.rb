class Feeder
  BASE_URL = 'http://ichart.finance.yahoo.com/table.csv'
  attr_reader :bars

  def initialize start_date, end_date, symbols, fetch_on_init=true
    @start_date = start_date
    @end_date = end_date
    @symbols = symbols
    @bars = {}
    fetch if fetch_on_init
  end

  def fetch
    hydra = Typhoeus::Hydra.new
    @symbols.each do |symbol|
      params = {
        s: symbol,
        a: @start_date.month - 1,
        b: @start_date.day,
        c: @start_date.year,
        d: @end_date.month - 1,
        e: @end_date.day,
        f: @end_date.year,
        ignore: '.csv'
      }
      request = Typhoeus::Request.new BASE_URL, params: params
      request.on_complete(&method(:on_complete))
      hydra.queue request
    end
    hydra.run
  end

  def start
    (@start_date..@end_date).each do |date|
      date_str = date.strftime '%Y-%m-%d'
      latest_bar = @bars[date_str]
      $last_closing_prices = latest_bar.bar_data if latest_bar.present?
      $last_date = date_str
      emit bar: latest_bar
    end
  end

  private

  def add_bar symbol, hash
    date = hash[:date]
    @bars[date] ||= Bar.new date
    @bars[date].add_bar_data symbol, hash
  end

  def on_complete response
    if response.success?
      request = response.request
      begin
        stock_symbol = request.options[:params][:s].to_s.downcase.to_sym
      rescue
        return stock_symbol
      end
      CSV.parse(response.body, headers: true, header_converters: :symbol) do |row|
        row = row.to_hash
        next if row[:date].blank?
        add_bar stock_symbol, row
      end
    elsif response.timed_out?
      # aw hell no
      puts '[ERROR] got a time out'
    elsif response.code == 0
      # Could not get an http response, something's wrong.
      puts "[ERROR] response.return_message"
    else
      # Received a non-successful http response.
      puts "[ERROR] HTTP request failed: " + response.code.to_s
    end
  end
end
