require 'spec_helper'

RSpec.describe ShipmentCalculator::Rules::ThirdLargeFreeRule do
  subject(:rule) { described_class.new(transactions) }

  let(:transactions) { double('transactions') }
  let(:large_transactions) { double('large_transactions') }

  describe '#transactions' do
    before do
      allow(transactions).to receive(:select).and_return(large_transactions)
    end

    it 'has transactions' do
      expect(rule.transactions).to eq(large_transactions)
    end
  end

  describe '#apply' do
    let(:providers) do
      [build(:provider, :lp, sizes_with_prices: { 'L' => 6.9 }),
       build(:provider, :mr, sizes_with_prices: { 'L' => 4 })]
    end

    before do
      allow(ShipmentCalculator).to receive(:providers).and_return(providers)
      rule.apply
    end

    context 'when shipment is Large (L)' do
      context 'when provider is LP' do
        context 'when transactions are on the same month' do
          let(:transactions) do
            (1..6).map do |day|
              build(:transaction, :large, :lp, date: Date.parse("2019-02-0#{day}"))
            end
          end

          it 'applies discount to the third transaction', :aggregate_failures do
            expect(transactions[2].shipment_price).to eq(0)
            expect(transactions[2].discount).to eq(6.9)
          end

          # Separated this one from the next test to have more clarity.
          it 'applies discount only once', :aggregate_failures do
            # 6'th transaction has no repeating discount.
            expect(transactions[5].shipment_price).to eq(6.9)
            expect(transactions[5].discount).to eq(0)
          end

          it 'sets regular price for other LP transactions', :aggregate_failures do
            [0, 1, 3, 4].each do |index|
              expect(transactions[index].shipment_price).to eq(6.9)
              expect(transactions[index].discount).to eq(0)
            end
          end
        end

        context 'when there are multiple transactions on different months' do
          let(:transactions) do
            (1..6).map do |day|
              month = (day <= 3 ? 2 : 3)
              build(:transaction, :large, :lp, date: Date.parse("2019-0#{month}-0#{day}"))
            end
          end

          it 'applies discount to the third transaction of each month', :aggregate_failures do
            [2, 5].each do |index|
              expect(transactions[index].shipment_price).to eq(0)
              expect(transactions[index].discount).to eq(6.9)
            end
          end

          it 'sets regular price for other LP transactions', :aggregate_failures do
            [0, 1, 3, 4].each do |index|
              expect(transactions[index].shipment_price).to eq(6.9)
              expect(transactions[index].discount).to eq(0)
            end
          end
        end

        context 'when there are different year transactions with the same month' do
          let(:transactions) do
            (1..6).map do |day|
              year = (day <= 3 ? 2018 : 2019)
              build(:transaction, :large, :lp, date: Date.parse("#{year}-02-0#{day}"))
            end
          end

          it 'applies discount for different year same month transactions', :aggregate_failures do
            [2, 5].each do |index|
              expect(transactions[index].shipment_price).to eq(0)
              expect(transactions[index].discount).to eq(6.9)
            end
          end
        end
      end

      context 'when provider is not LP' do
        let(:transactions) { [build(:transaction, :large, :mr)] }

        it 'ignores transactions' do
          expect(rule.transactions).to be_empty
        end
      end
    end

    context 'when shipments are not Large (L)' do
      let(:transactions) { [build(:transaction, :small, :mr)] }

      it 'ignores transactions' do
        expect(rule.transactions).to be_empty
      end
    end

    context 'when shipments are mixed sizes' do
      let(:transactions) { small_transactions + large_transactions }
      let(:small_transactions) do
        (1..2).map do |day|
          build(:transaction, :small, :lp, date: Date.parse("2015-02-0#{day}"))
        end
      end

      let(:large_transactions) do
        (3..5).map do |day|
          build(:transaction, :large, :lp, date: Date.parse("2015-02-0#{day}"))
        end
      end

      it 'does not add discount for absolute third transaction', :aggregate_failures do
        expect(rule.transactions.first.shipment_price).to eq(6.9)
        expect(rule.transactions.first.discount).to eq(0)
      end

      it 'adds discount for third large LP transaction', :aggregate_failures do
        expect(rule.transactions[2].shipment_price).to eq(0)
        expect(rule.transactions[2].discount).to eq(6.9)
      end
    end
  end
end
