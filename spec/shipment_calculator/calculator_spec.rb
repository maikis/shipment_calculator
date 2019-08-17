require 'spec_helper'

RSpec.describe ShipmentCalculator::Calculator do
  subject(:calculator) { described_class.new(shipment_data, rules) }

  let(:rules) { [double('rule')] }
  let(:shipment_data) { double('data') }

  describe '#shipment_data' do
    it 'has shipment data' do
      expect(calculator.shipment_data).to eq(shipment_data)
    end
  end

  describe '#rules' do
    it 'has calculation rules' do
      expect(calculator.rules).to eq(rules)
    end
  end
end
