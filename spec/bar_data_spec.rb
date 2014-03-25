require 'spec_helper'

describe BarData do
  context "when data can be set for FIELDS" do
    before(:all) do
      @bar_data = BarData.new symbol: 'aapl', date: '2014-01-02',
        open: 500, high: 600, low: 400, close: 550, adj_close: 450
    end

    it { expect(@bar_data.symbol).to eql('aapl') }
    it { expect(@bar_data.date).to eql('2014-01-02') }
    it { expect(@bar_data.open).to eql(500) }
    it { expect(@bar_data.high).to eql(600) }
    it { expect(@bar_data.low).to eql(400) }
    it { expect(@bar_data.close).to eql(550) }
    it { expect(@bar_data.adj_close).to eql(450) }
  end
end
