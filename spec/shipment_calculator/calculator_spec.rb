require 'spec_helper'

RSpec.describe ShipmentCalculator::Calculator do
  subject(:calculator) { described_class.new(transaction_data, rules) }

  let(:rules) { [double('rule')] }
  let(:transaction_data) { double('data') }

  describe '#transaction_data' do
    it 'has shipment data' do
      expect(calculator.transaction_data).to eq(transaction_data)
    end
  end

  describe '#rules' do
    it 'has calculation rules' do
      expect(calculator.rules).to eq(rules)
    end
  end
end
