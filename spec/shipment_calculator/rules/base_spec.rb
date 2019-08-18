require 'spec_helper'

RSpec.describe ShipmentCalculator::Rules::Base do
  subject(:base_rule) { described_class.new }

  class TestRule < ShipmentCalculator::Rules::Base
  end

  context 'when subclass has no #shipment_price method' do
    it 'raises error' do
      expect { TestRule.new.shipment_price }.to raise_error(NotImplementedError)
    end
  end

  context 'when subclass has no #discount method' do
    it 'raises error' do
      expect { TestRule.new.discount }.to raise_error(NotImplementedError)
    end
  end

  context 'when subclass has #shipment_price method' do
    let(:test_rule) { TestRule.new }

    before do
      class << test_rule
        def shipment_price
          'it works'
        end
      end
    end

    it 'does not raise error' do
      expect { test_rule.shipment_price }.not_to raise_error
    end
  end

  context 'when subclass has #discount method' do
    let(:test_rule) { TestRule.new }

    before do
      class << test_rule
        def discount
          'it works'
        end
      end
    end

    it 'does not raise error' do
      expect { test_rule.discount }.not_to raise_error
    end
  end

  describe '#providers' do
    let(:provider_config) { { 'MR' => { 'S' => 2 }, 'LP' => { 'S' => 1.5 } } }

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

    it 'has providers' do
      expect(base_rule.providers).to include(ShipmentCalculator::Provider)
    end
  end
end
