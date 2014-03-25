require 'spec_helper'

describe Feeder do
  describe '#fetch' do
    context "when fetching 2014-01-02 AAPL data" do
      before :all do
        start_date = Date.parse '2014-01-02'
        end_date = Date.parse '2014-01-02'
        symbols = %w{ AAPL }
        @feeder = Feeder.new start_date, end_date, symbols
      end

      it { expect(@feeder.bars['2014-01-02']).to be_instance_of(Bar) }
      it { expect(@feeder.bars['2014-01-02'].date).to eql('2014-01-02') }
      it { expect(@feeder.bars['2014-01-02'].bar_data[:aapl]).to be_instance_of(Hash) }
      it { expect(@feeder.bars['2014-01-02'].bar_data[:aapl][:date]).to eql('2014-01-02') }
      it { expect(@feeder.bars['2014-01-02'].bar_data[:aapl][:open]).to eql('555.68') }
      it { expect(@feeder.bars['2014-01-02'].bar_data[:aapl][:high]).to eql('557.03') }
      it { expect(@feeder.bars['2014-01-02'].bar_data[:aapl][:low]).to eql('552.02') }
      it { expect(@feeder.bars['2014-01-02'].bar_data[:aapl][:close]).to eql('553.13') }
      it { expect(@feeder.bars['2014-01-02'].bar_data[:aapl][:adj_close]).to eql('549.84') }
      it { expect(@feeder.bars['2014-01-02'].bar_data[:aapl][:symbol]).to eql(:aapl) }
    end


    context "when fetching 2014-01-02 to 2014-01-03 AAPL and GOOG data" do
      before :all do
        start_date = Date.parse '2014-01-02'
        end_date = Date.parse '2014-01-03'
        symbols = %w{ AAPL GOOG }
        @feeder = Feeder.new start_date, end_date, symbols
      end

      it { expect(@feeder.bars['2014-01-02']).to be_instance_of(Bar) }
      it { expect(@feeder.bars['2014-01-02'].date).to eql('2014-01-02') }
      it { expect(@feeder.bars['2014-01-02'].bar_data[:aapl]).to be_instance_of(Hash) }
      it { expect(@feeder.bars['2014-01-02'].bar_data[:aapl][:date]).to eql('2014-01-02') }
      it { expect(@feeder.bars['2014-01-02'].bar_data[:aapl][:open]).to eql('555.68') }
      it { expect(@feeder.bars['2014-01-02'].bar_data[:aapl][:high]).to eql('557.03') }
      it { expect(@feeder.bars['2014-01-02'].bar_data[:aapl][:low]).to eql('552.02') }
      it { expect(@feeder.bars['2014-01-02'].bar_data[:aapl][:close]).to eql('553.13') }
      it { expect(@feeder.bars['2014-01-02'].bar_data[:aapl][:adj_close]).to eql('549.84') }
      it { expect(@feeder.bars['2014-01-02'].bar_data[:aapl][:symbol]).to eql(:aapl) }
      it { expect(@feeder.bars['2014-01-02']).to be_instance_of(Bar) }

      it { expect(@feeder.bars['2014-01-02'].date).to eql('2014-01-02') }
      it { expect(@feeder.bars['2014-01-02'].bar_data[:goog]).to be_instance_of(Hash) }
      it { expect(@feeder.bars['2014-01-02'].bar_data[:goog][:date]).to eql('2014-01-02') }
      it { expect(@feeder.bars['2014-01-02'].bar_data[:goog][:open]).to eql('1115.46') }
      it { expect(@feeder.bars['2014-01-02'].bar_data[:goog][:high]).to eql('1117.75') }
      it { expect(@feeder.bars['2014-01-02'].bar_data[:goog][:low]).to eql('1108.26') }
      it { expect(@feeder.bars['2014-01-02'].bar_data[:goog][:close]).to eql('1113.12') }
      it { expect(@feeder.bars['2014-01-02'].bar_data[:goog][:adj_close]).to eql('1113.12') }
      it { expect(@feeder.bars['2014-01-02'].bar_data[:goog][:symbol]).to eql(:goog) }

      it { expect(@feeder.bars['2014-01-03']).to be_instance_of(Bar) }
      it { expect(@feeder.bars['2014-01-03'].date).to eql('2014-01-03') }
      it { expect(@feeder.bars['2014-01-03'].bar_data[:aapl]).to be_instance_of(Hash) }
      it { expect(@feeder.bars['2014-01-03'].bar_data[:aapl][:date]).to eql('2014-01-03') }
      it { expect(@feeder.bars['2014-01-03'].bar_data[:aapl][:open]).to eql('552.86') }
      it { expect(@feeder.bars['2014-01-03'].bar_data[:aapl][:high]).to eql('553.70') }
      it { expect(@feeder.bars['2014-01-03'].bar_data[:aapl][:low]).to eql('540.43') }
      it { expect(@feeder.bars['2014-01-03'].bar_data[:aapl][:close]).to eql('540.98') }
      it { expect(@feeder.bars['2014-01-03'].bar_data[:aapl][:adj_close]).to eql('537.76') }
      it { expect(@feeder.bars['2014-01-03'].bar_data[:aapl][:symbol]).to eql(:aapl) }
      it { expect(@feeder.bars['2014-01-03']).to be_instance_of(Bar) }

      it { expect(@feeder.bars['2014-01-03'].date).to eql('2014-01-03') }
      it { expect(@feeder.bars['2014-01-03'].bar_data[:goog]).to be_instance_of(Hash) }
      it { expect(@feeder.bars['2014-01-03'].bar_data[:goog][:date]).to eql('2014-01-03') }
      it { expect(@feeder.bars['2014-01-03'].bar_data[:goog][:open]).to eql('1115.00') }
      it { expect(@feeder.bars['2014-01-03'].bar_data[:goog][:high]).to eql('1116.93') }
      it { expect(@feeder.bars['2014-01-03'].bar_data[:goog][:low]).to eql('1104.93') }
      it { expect(@feeder.bars['2014-01-03'].bar_data[:goog][:close]).to eql('1105.00') }
      it { expect(@feeder.bars['2014-01-03'].bar_data[:goog][:adj_close]).to eql('1105.00') }
      it { expect(@feeder.bars['2014-01-03'].bar_data[:goog][:symbol]).to eql(:goog) }
    end
  end
end
