require 'spec_helper'

RSpec.describe ShipmentCalculator::StdoutFormatter do
  subject(:formatter) { described_class.new() }

  describe '#output_result' do
    let(:size) { 'L' }
    let(:provider) { 'LP' }
    let(:result_object) { ShipmentCalculator::Result.new(transactions, formatter) }
    let(:date) { Date.parse("2019-02-01") }
    let(:shipment_price) { 1 }
    let(:discount) { 2 }
    let(:transactions) { [transaction] }
    let(:transaction) do
      transaction = ShipmentCalculator::Transaction.new(date, size, provider)
      transaction.shipment_price = shipment_price
      transaction.discount = discount
      transaction
    end

    let(:transaction_details) do
      "#{transaction.date} #{transaction.size} #{transaction.short_name}"\
      " #{transaction.shipment_price} #{transaction.discount}\n"
    end

    context 'when transaction is valid' do
      it 'outputs transaction with details to STDOUT using two decimals format' do
        expect { result_object.output_result }.to output(/2019-02-01 L LP 1.00 2.00/).to_stdout
      end

      context 'when transaction has no discount (discount == 0)' do
        let(:discount) { 0 }

        it 'outputs "-" instead of 0' do
          expect { result_object.output_result }.to output(/2019-02-01 L LP 1.00 -/).to_stdout
        end
      end
    end

    context 'when transaction is not valid' do
      let(:date) { '2019-02-01' }
      let(:size) { 'CUSPS' }
      let(:provider) { nil }

      it 'appends "Ignored" to transaction details' do
        expect { result_object.output_result }.to output(/2019-02-01 CUSPS Ignored/).to_stdout
      end
    end
  end
end
