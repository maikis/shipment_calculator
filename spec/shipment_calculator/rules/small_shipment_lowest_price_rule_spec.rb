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

    let(:transactions) { [transaction1, transaction2] }
    let(:transaction1) { build(:transaction, :small, :mr) }
    let(:transaction2) { build(:transaction, :small, :lp) }

    let(:providers) do
      [build(:provider, :mr, sizes_with_prices: { 'S' => 2 }),
       build(:provider, :lp, sizes_with_prices: { 'S' => 1.5 })]
    end


    before do
      allow(ShipmentCalculator).to receive(:providers).and_return(providers)
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
      let(:transactions) { [build(:transaction, :mr)] }

      it 'does not set anything', :aggregate_failures do
        expect(transactions.first.shipment_price).to be_nil
        expect(transactions.first.discount).to be_nil
      end
    end
  end
end
