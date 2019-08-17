require 'spec_helper'

RSpec.describe ShipmentCalculator::Transaction do
  subject(:transaction) { described_class.new(date, size, provider) }

  let(:date) { double('date') }
  let(:size) { double('size') }
  let(:provider) { double('provider') }

  describe '#date' do
    it 'has date' do
      expect(transaction.date).to eq(date)
    end
  end

  describe '#size' do
    it 'has size' do
      expect(transaction.size).to eq(size)
    end
  end

  describe '#provider' do
    it 'has provider' do
      expect(transaction.provider).to eq(provider)
    end
  end
end
