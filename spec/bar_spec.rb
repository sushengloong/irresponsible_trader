require 'spec_helper'

describe Bar do
  before :each do
    @bar = Bar.new '2014-01-02'
  end

  describe '#new' do
    it { expect(@bar.date).to eql('2014-01-02') }
    it { expect(@bar.bar_data).to be_empty }
  end

  describe '#add_bar_data' do
    context 'when passing correct date' do
      before :each do
        @bar.add_bar_data :aapl, { test: 100, date: '2014-01-02' }
      end

      it { expect(@bar.bar_data).to be_present }
      it { expect(@bar.bar_data[:aapl]).to be_present }
      it { expect(@bar.bar_data[:aapl][:test]).to eql(100) }
      it { expect(@bar.bar_data[:aapl][:symbol]).to eql(:aapl) }
    end

    context 'when passing incorrect date' do
      it {
        expect { @bar.add_bar_data :aapl, { test: 100 } }.to raise_error
      }

      it {
        expect { @bar.add_bar_data :aapl, { test: 100, date: '2014-01-03' } }.to raise_error
      }
    end
  end
end
