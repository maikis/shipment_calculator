require 'spec_helper'

RSpec.describe ShipmentCalculator do
  describe '.providers' do
    before do
      allow(Psych).to receive(:load_file).with('config/providers.yml').and_return({ 'MR' => { 'S' => 1 } })
    end

    it 'returns array' do
      expect(ShipmentCalculator.providers).to be_an(Array)
    end

    it 'returns Provider instances' do
      expect(ShipmentCalculator.providers).to include(ShipmentCalculator::Provider)
    end
  end
end
