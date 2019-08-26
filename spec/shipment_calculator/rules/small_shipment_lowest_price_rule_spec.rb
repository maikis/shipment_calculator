require 'spec_helper'

RSpec.describe ShipmentCalculator::Rules::SmallShipmentLowestPriceRule do
  subject(:rule) { described_class.new(transactions) }

  let(:transactions) { double('transactions') }
  let(:small_transactions) { double('small_transactions') }

  describe '#transactions' do
    before do
      allow(transactions).to receive(:select).and_return(small_transactions)
    end

    it 'has transactions' do
      expect(rule.transactions).to eq(small_transactions)
    end
  end

  describe '#apply' do
    subject(:rule) { described_class.new(transactions) }

    let(:provider_config) { { 'MR' => { 'S' => 2 }, 'LP' => { 'S' => 1.5 } } }
    let(:date) { Date.parse('2015-02-01') }
    let(:size) { 'S' }
    let(:provider) { 'MR' }
    let(:other_provider) { 'LP' }
    let(:transactions) { [transaction1, transaction2] }

    let(:transaction1) do
      ShipmentCalculator::Transaction.new(date, size, provider)
    end

    let(:transaction2) do
      ShipmentCalculator::Transaction.new(date, size, other_provider)
    end

    let(:all_providers) do
      [ShipmentCalculator::Provider.new(
         provider_config.keys[0],
         provider_config.values[0]
       ),
       ShipmentCalculator::Provider.new(
        provider_config.keys[1],
        provider_config.values[1]
       )]
    end


    before do
      allow(ShipmentCalculator).to receive(:providers).and_return(all_providers)
      rule.apply
    end

    context 'when transacion is small size' do
      context 'when transaction has not cheapest provider' do
        it 'applies lower price for transaction' do
          expect(transaction1.shipment_price).to eq(1.5)
        end

        it 'applies discount for transaction' do
          expect(transaction1.discount).to eq(0.5)
        end
      end

      context 'when provider has cheapest provider' do
        it 'applies providers price for transaction' do
          expect(transaction2.shipment_price).to eq(1.5)
        end

        it 'applies no discounts for transaction' do
          expect(transaction2.discount).to eq(0)
        end
      end
    end

    context 'when transaction is not small size' do
      let(:size) { 'XL' }

      it 'does not set anything', :aggregate_failures do
        expect(transaction1.shipment_price).to be_nil
        expect(transaction1.discount).to be_nil
      end
    end
  end
end
