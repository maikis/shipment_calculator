require 'spec_helper'

RSpec.describe ShipmentCalculator::Transaction do
  subject(:transaction) { described_class.new(date, size, short_name) }

  let(:date) { Date.parse('2015-02-01') }
  let(:size) { 'S' }
  let(:short_name) { 'MR' }

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

  describe '#short_name' do
    it 'has short_name' do
      expect(transaction.short_name).to eq(short_name)
    end
  end

  describe '#valid?' do
    let(:sizes_with_prices) { { 'S' => 1 } }
    let(:providers) { [provider] }
    let(:provider_short_name) { 'MR' }
    let(:provider) do
      ShipmentCalculator::Provider.new(provider_short_name, sizes_with_prices)
    end

    before do
      allow(ShipmentCalculator).to receive(:providers).and_return(providers)
    end

    context 'when date is invalid' do
      let(:date) { nil }

      it 'returns false' do
        expect(transaction.valid?).to eq(false)
      end
    end

    context 'when size is unrecognized' do
      let(:size) { 'XL' }

      it 'returns false' do
        expect(transaction.valid?).to eq(false)
      end
    end

    context 'when provider is unrecognized' do
      let(:short_name) { 'UNRECOGNIZED' }

      it 'returns false' do
        expect(transaction.valid?).to eq(false)
      end
    end

    context 'when all attributes are valid' do
      it 'returns true' do
        expect(transaction.valid?).to eq(true)
      end
    end
  end
end
