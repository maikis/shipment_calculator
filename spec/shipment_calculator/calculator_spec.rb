require 'spec_helper'

RSpec.describe ShipmentCalculator::Calculator do
  subject(:calculator) { described_class.new(transactions, rules) }

  let(:valid_transaction) { double }
  let(:rules) { double }
  let(:transactions) { [valid_transaction] }

  before do
    allow(valid_transaction).to receive(:valid?).and_return(true)
  end

  describe '#rules' do
    it 'has rules' do
      expect(calculator.rules).to eq(rules)
    end
  end

  describe '#valid_transactions' do
    let(:invalid_transaction) { double }
    let(:transactions) { [invalid_transaction, valid_transaction] }

    before do
      allow(invalid_transaction).to receive(:valid?).and_return(false)
    end

    it 'returns only transactions that are valid' do
      expect(calculator.valid_transactions).to eq([valid_transaction])
    end
  end

  describe '#basic_calculate' do
    let(:rule) { double }
    let(:rules) { [rule] }

    before do
      # Not sure if there is a better way :|
      allow(rule).to receive(:new).and_return(rule)
    end

    it 'uses rules to calculate result' do
      expect(rule).to receive(:apply).once
      calculator.basic_calculate
    end
  end
end
