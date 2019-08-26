require 'spec_helper'

RSpec.describe ShipmentCalculator::Provider do
  subject(:provider) { described_class.new('MR', sizes_with_prices) }

  let(:sizes_with_prices) { { 'S' => 2, 'M' => 3, 'L' => 4 } }

  describe '#short_name' do
    it 'has short name' do
      expect(provider.short_name).to eq('MR')
    end
  end

  describe '#sizes_with_prices' do
    it 'has sizes and prices hash' do
      expect(provider.sizes_with_prices).to eq(sizes_with_prices)
    end
  end

  describe '#price_by_size' do
    let(:size) { 'S' }

    it 'returns price for provided size' do
      expect(provider.price_by_size(size)).to eq(2)
    end
  end

  describe '#includes_size?' do
    context 'when size is included' do
      let(:valid_size) { 'S' }

      it 'returns true' do
        expect(provider.includes_size?(valid_size)).to eq(true)
      end
    end

    context 'when size is not included' do
      let(:invalid_size) { 'XL' }

      it 'returns true' do
        expect(provider.includes_size?(invalid_size)).to eq(false)
      end
    end
  end

  describe '.all' do
    subject(:provider_class) { described_class }

    let(:providers) do
      [ShipmentCalculator::Provider.new('MR', {'S' => '1'}),
       ShipmentCalculator::Provider.new('LP', {'M' => '2'})]
    end

    before do
      allow(ShipmentCalculator).to receive(:providers).and_return(providers)
    end

    it 'returns all providers' do
      expect(provider_class.all).to eq(providers)
    end
  end
end