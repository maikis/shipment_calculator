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
    let(:transaction) { build(:transaction, :large, :lp, :with_discount) }
    let(:transactions) { [transaction] }

    before do
      rule.apply
    end

    context 'when budget is not used out' do
      it 'leaves applied discount', :aggregate_failures do
        expect(transaction.shipment_price).to eq(2)
        expect(transaction.discount).to eq(1)
      end

      it 'subtracts from monthly budget' do
        expect(rule.current_budget).to eq(9) # 10 - 1 (transaction discount).
      end
    end

    context 'when budget completely used' do
      subject(:rule) { described_class.new(transactions, 0) }

      it 'removes applied discount', :aggregate_failures do
        expect(transaction.shipment_price).to eq(3)
        expect(transaction.discount).to eq(0)
      end

      it 'does not subtract from monthly budget' do
        expect(rule.current_budget).to eq(0)
      end
    end

    context 'when budget is not used out but not sufficient for full discount' do
      subject(:rule) { described_class.new(transactions, 0.3) }

      it 'leaves discount partially applied', :aggregate_failures do
        expect(transaction.shipment_price).to eq(2.7)
        expect(transaction.discount).to eq(0.3)
      end

      it 'subtracts from monthly budget' do
        expect(rule.current_budget).to eq(0)
      end
    end

    context 'when couple month data is present' do
      subject(:rule) { described_class.new(transactions, 1) }

      let(:transaction1) { build(:transaction, :large, :lp, :with_discount) }
      let(:transaction2) do
        build(:transaction, :large, :lp, :with_discount, date: Date.parse('2019-03-01'))
      end

      let(:transactions) do
        [transaction1, transaction2]
      end

      it 'applies budget for each month', :aggregate_failures do
        expect(transaction1.discount).to eq(1)
        expect(transaction2.discount).to eq(1)
      end
    end

    context 'when transaction has no discount present' do
      let(:transactions) { [build(:transaction, :large, :lp, :with_discount)] }

      it 'does not raise error' do
        expect { rule.apply }.not_to raise_error
      end
    end
  end
end
