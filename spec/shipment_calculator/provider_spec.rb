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
    it 'returns price for provided size' do
      expect(provider.price_by_size('S')).to eq(2)
    end
  end
end