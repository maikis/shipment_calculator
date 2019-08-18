require 'spec_helper'

RSpec.describe ShipmentCalculator do
  subject(:shipment_calculator) { described_class }

  describe '.providers' do
    before do
      allow(Psych).to receive(:load_file).with('config/providers.yml')
        .and_return({ 'MR' => { 'S' => 1 } })
    end

    it 'has providers' do
      expect(shipment_calculator.providers).to include(ShipmentCalculator::Provider)
    end
  end
end
