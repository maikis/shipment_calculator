require 'spec_helper'

RSpec.describe ShipmentCalculator::Rules::BudgetRule do
  subject(:rule) { described_class.new(transactions) }

  let(:transactions) { double('transactions') }

  describe '#transactions' do
    it 'has transactions' do
      expect(rule.transactions).to eq(transactions)
    end
  end

  describe '#apply' do
    subject(:result) { rule.apply }

    let(:large_size) { 'L' }
    let(:provider_config) { { 'LP' => { large_size => 6.9 } } }

    let(:all_providers) do
      [ShipmentCalculator::Provider.new(
         provider_config.keys.first,
         provider_config.values.first
       )]
    end

    let(:transactions) do
      transaction = ShipmentCalculator::Transaction.new(
        Date.parse("2019-02-01"), large_size, 'LP'
      )
      transaction.shipment_price = 1
      transaction.discount = 1
      [transaction]
    end

    before do
      allow(ShipmentCalculator).to receive(:providers).and_return(all_providers)
      result
    end

    context 'when budget is not used out' do
      it 'leaves applied discount', :aggregate_failures do
        expect(result.first.shipment_price).to eq(1)
        expect(result.first.discount).to eq(1)
      end

      it 'subtracts from monthly budget' do
        expect(rule.monthly_budget).to eq(9) # 10 - 1 (transaction discount).
      end
    end

    context 'when budget completely used' do
      subject(:rule) { described_class.new(transactions, 0) }

      it 'removes applied discount', :aggregate_failures do
        expect(result.first.shipment_price).to eq(2)
        expect(result.first.discount).to eq(0)
      end

      it 'does not subtract from monthly budget' do
        expect(rule.monthly_budget).to eq(0)
      end
    end

    context 'when budget is not used out but not sufficient for full discount' do
      subject(:rule) { described_class.new(transactions, 0.3) }

      it 'leaves discount partially applied', :aggregate_failures do
        expect(result.first.shipment_price).to eq(1.3)
        expect(result.first.discount).to eq(0.7)
      end

      it 'subtracts from monthly budget' do
        expect(rule.monthly_budget).to eq(0)
      end
    end

    context 'when couple month data is present' do
      subject(:rule) { described_class.new(transactions, 1) }

      let(:transaction1) do
        transaction = ShipmentCalculator::Transaction.new(
          Date.parse("2019-02-01"), large_size, 'LP'
        )
        transaction.shipment_price = 1
        transaction.discount = 1
        transaction
      end

      let(:transaction2) do
        transaction = ShipmentCalculator::Transaction.new(
          Date.parse("2019-03-01"), large_size, 'LP'
        )
        transaction.shipment_price = 1
        transaction.discount = 1
        transaction
      end

      let(:transactions) do
        [transaction1, transaction2]
      end

      it 'applies budget for each month', :aggregate_failures do
        expect(result.first.discount).to eq(1)
        expect(result.first.discount).to eq(1)
      end
    end

    context 'when transaction has no discount present' do
      let(:transactions) do
        transaction = ShipmentCalculator::Transaction.new(
          Date.parse("2019-02-01"), large_size, 'LP'
        )
        [transaction]
      end

      it 'does not raise error' do
        expect { result }.not_to raise_error
      end
    end
  end
end
