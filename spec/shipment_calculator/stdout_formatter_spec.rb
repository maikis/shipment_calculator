require 'spec_helper'

RSpec.describe ShipmentCalculator::StdoutFormatter do
  subject(:formatter) { described_class.new() }

  describe '#output_result' do
    let(:transactions) { [transaction] }
    let(:transaction) { build(:transaction, :large, :lp, :with_discount) }
    let(:result_object) do
      build(:result, transactions: transactions, formatter: formatter)
    end

    context 'when transaction is valid' do
      it 'outputs transaction with details to STDOUT using two decimals format' do
        expect { result_object.output_result }
          .to output(/2015-02-01 L LP 2.00 1.00/).to_stdout
      end

      context 'when transaction has no discount (discount == 0)' do
        let(:transaction) { build(:transaction, :large, :lp, :no_discount) }

        it 'outputs "-" instead of 0' do
          expect { result_object.output_result }
            .to output(/2015-02-01 L LP 2.00 -/).to_stdout
        end
      end
    end

    context 'when transaction is not valid' do
      let(:transaction) { build(:transaction, :not_valid) }

      it 'appends "Ignored" to transaction details' do
        expect { result_object.output_result }
          .to output(/2015-02-01 CUSPS Ignored/).to_stdout
      end
    end
  end
end
