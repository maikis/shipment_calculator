require 'spec_helper'

RSpec.describe ShipmentCalculator::Result do
  subject(:result) { described_class.new(transaction, shipment_price, discount) }

  let(:transaction) { double('transaction') }
  let(:shipment_price) { double('shipment_price') }
  let(:discount) { double('discount') }

  describe '#transaction' do
    it 'has transaction' do
      expect(result.transaction).to eq(transaction)
    end
  end

  describe '#shipment_price' do
    it 'has final price after applying rule' do
      expect(result.shipment_price).to eq(shipment_price)
    end
  end

  describe '#discount' do
    it 'has applied discount' do
      expect(result.discount).to eq(discount)
    end
  end
end
