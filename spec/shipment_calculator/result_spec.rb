require 'spec_helper'

RSpec.describe ShipmentCalculator::Result do
  subject(:result) { described_class.new(transactions, formatter) }

  let(:transactions) { double('transactions') }
  let(:formatter) { double('formatter') }

  it 'has transactions' do
    expect(result.transactions).to eq(transactions)
  end

  it 'has formatter' do
    expect(result.formatter).to eq(formatter)
  end

  describe '#output_result' do
    it 'calls formatter\'s output method' do
      expect(formatter).to receive(:output_result).with(result)
      result.output_result
    end
  end
end
