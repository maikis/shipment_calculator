require 'spec_helper'

RSpec.describe ShipmentCalculator::Rules::ThirdLargeFreeRule do
  subject(:rule) { described_class.new(transactions) }

  let(:transactions) { double('transactions') }

  describe '#transactions' do
    it 'has transactions' do
      expect(rule.transactions).to eq(transactions)
    end
  end

  describe '#apply' do
    subject(:result) { rule.apply }

    let(:provider_config) { { 'LP' => { large_size => 6.9 }, 'MR' => { large_size => 4 } } }
    let(:large_size) { 'L' }

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
    end

    context 'when shipment is Large (L)' do
      context 'when provider is LP' do
        context 'when transactions are on the same month' do
          let(:transactions) do
            (1..6).map do |day|
              ShipmentCalculator::Transaction.new(
                Date.parse("2019-02-0#{day}"), large_size, 'LP'
              )
            end
          end

          it 'applies discount to the third transaction', :aggregate_failures do
            expect(result[2].shipment_price).to eq(0)
            expect(result[2].discount).to eq(6.9)
          end

          # Separated this one from the next test to have more clarity.
          it 'applies discount only once', :aggregate_failures do
            # 6'th transaction has no repeating discount.
            expect(result[5].shipment_price).to eq(6.9)
            expect(result[5].discount).to eq(0)
          end

          it 'sets regular price for other LP transactions', :aggregate_failures do
            [0, 1, 3, 4].each do |index|
              expect(result[index].shipment_price).to eq(6.9)
              expect(result[index].discount).to eq(0)
            end
          end
        end

        context 'when there are multiple transactions on different months' do
          let(:transactions) do
            (1..6).map do |day|
              month = (day <= 3 ? 2 : 3)
              ShipmentCalculator::Transaction.new(
                Date.parse("2019-0#{month}-0#{day}"), large_size, 'LP'
              )
            end
          end

          it 'applies discount to the third transaction of each month', :aggregate_failures do
            [2, 5].each do |index|
              expect(result[index].shipment_price).to eq(0)
              expect(result[index].discount).to eq(6.9)
            end
          end

          it 'sets regular price for other LP transactions', :aggregate_failures do
            [0, 1, 3, 4].each do |index|
              expect(result[index].shipment_price).to eq(6.9)
              expect(result[index].discount).to eq(0)
            end
          end
        end

        context 'when there are different year transactions with the same month' do
          let(:transactions) do
            (1..6).map do |day|
              year = (day <= 3 ? 2018 : 2019)
              ShipmentCalculator::Transaction.new(
                Date.parse("#{year}-02-0#{day}"), large_size, 'LP'
              )
            end
          end

          it 'applies discount for different year same month transactions', :aggregate_failures do
            [2, 5].each do |index|
              expect(result[index].shipment_price).to eq(0)
              expect(result[index].discount).to eq(6.9)
            end
          end
        end
      end

      context 'when provider is not LP' do
        let(:transactions) do
          (1..3).map do |day|
            ShipmentCalculator::Transaction.new(
              Date.parse("2015-02-0#{day}"), large_size, 'MR'
            )
          end
        end

        it 'sets regular price for all transactions', :aggregate_failures do
          (0..2).each do |index|
            expect(result[index].shipment_price).to eq(4)
            expect(result[index].discount).to eq(0)
          end
        end
      end
    end

    # Probably single transaction would be sufficient in this context, but I
    # decided to check if it really works well with multiple transactions too.
    context 'when shipments are not Large (L)' do
      let(:small_size) { 'S' }
      let(:provider) { 'LP' }
      let(:transactions) do
        (1..2).map do |day|
          ShipmentCalculator::Transaction.new(
            Date.parse("2015-02-0#{day}"), small_size, provider
          )
        end
      end

      it 'ignores transaction' do
        (0..1).each do |index|
          expect(result[index].shipment_price).to be_nil
          expect(result[index].discount).to be_nil
        end
      end
    end
  end
end
